import gleam/int
import gleam/list
import gleam/string

pub fn pt_1(tokens: List(Token)) {
  use output, token <- list.fold(tokens, 0)

  case token {
    Mul(a, b) -> {
      output + { a * b }
    }
    _ -> output
  }
}

pub fn pt_2(tokens: List(Token)) {
  let output =
    list.fold(tokens, #(True, 0), fn(acc, token) {
      let #(multiply, output) = acc

      case token {
        Mul(a, b) -> {
          case multiply {
            True -> #(multiply, output + { a * b })
            False -> acc
          }
        }
        Do -> #(True, output)
        Dont -> #(False, output)
      }
    })

  output.1
}

pub type Token {
  Mul(Int, Int)
  Do
  Dont
}

pub type ParserToken(a) {
  PToken(a)
  Many(List(ParserToken(a)))
  Char(String)
  Sequence(String)
  Num(Int)
  NoToken
  SkipToken(ParserToken(a))
}

pub type ParseResult(a, b) {
  Success(ParserToken(a), String)
  ParseError(b)
}

type ParserFn(a) =
  fn(String) -> ParseResult(a, String)

/// This function is used by pt_1 and pt_2 to get the parsed output according to
/// gladvent's convention
/// It uses the parser to get the list of tokens but filters out any
/// unneccessary tokens and converts `ParseResult(Token)` to `List(Token)`
/// Assumption is made that at this point ParseResult will have list (`Many`)
pub fn parse(input: String) {
  let parsed =
    input
    |> parser()

  case parsed {
    Success(Many(list_of_tokens), _rest) -> {
      list_of_tokens
      |> list.filter_map(fn(token) {
        case token {
          PToken(pt) -> Ok(pt)
          _ -> Error("Not a ptoken")
        }
      })
    }
    _ -> []
  }
}

/// This is the main parser. It combines all the other parsers to get the final
/// result
pub fn parser() {
  drop_skip(many(choice([operations(), skip()])))
}

fn drop_skip(parser: ParserFn(a)) {
  parser
  |> map(fn(r) {
    case r {
      Success(Many(a), rest) ->
        a
        |> list.filter(fn(x) {
          case x {
            SkipToken(_) -> False
            _ -> True
          }
        })
        |> Many
        |> Success(rest)
      _ -> r
    }
  })
}

fn three_digit_num() {
  sequence([digit(), optional(digit()), optional(digit())])
  |> map(fn(r) {
    case r {
      Success(Many(nums), rest) -> {
        nums
        |> list.filter_map(fn(x) {
          case x {
            Num(num) -> Ok(num)
            _ -> Error("Not a num")
          }
        })
        |> list.fold(0, fn(acc, num) { acc * 10 + num })
        |> Num
        |> Success(rest)
      }
      _ -> r
    }
  })
}

fn skip() {
  char()
  |> map(fn(r) {
    case r {
      Success(a, r) -> Success(SkipToken(a), r)
      _ -> r
    }
  })
}

fn operations() {
  choice([multiply(), dont(), do()])
}

fn optional(parser: ParserFn(a)) {
  fn(input: String) {
    case parser(input) {
      Success(a, rest) -> Success(a, rest)
      ParseError(_) -> Success(SkipToken(NoToken), input)
    }
  }
}

fn multiply() {
  sequence([
    is_char("m"),
    is_char("u"),
    is_char("l"),
    is_char("("),
    three_digit_num(),
    is_char(","),
    three_digit_num(),
    is_char(")"),
  ])
  |> map(fn(r) {
    case r {
      Success(Many(mulval), rest) -> {
        case mulval {
          [_, _, _, _, a, _, b, _] -> {
            case a, b {
              Num(a), Num(b) -> Success(PToken(Mul(a, b)), rest)
              _, _ -> ParseError("Not a mul")
            }
          }
          _ -> ParseError("Not a mul")
        }
      }
      _ -> r
    }
  })
}

fn do() {
  sequence([is_char("d"), is_char("o"), is_char("("), is_char(")")])
  |> map(fn(r) {
    case r {
      Success(_, rest) -> Success(PToken(Do), rest)
      _ -> r
    }
  })
}

fn dont() {
  sequence([
    is_char("d"),
    is_char("o"),
    is_char("n"),
    is_char("'"),
    is_char("t"),
    is_char("("),
    is_char(")"),
  ])
  |> map(fn(r) {
    case r {
      Success(_, rest) -> Success(PToken(Dont), rest)
      _ -> r
    }
  })
}

fn is_char(x: String) {
  satisfy(char(), fn(r) {
    case r {
      Success(Char(x1), rest) -> {
        case x == x1 {
          True -> Success(Char(x1), rest)
          False -> ParseError("Not the char: " <> x)
        }
      }
      _ -> r
    }
  })
}

fn sequence(parsers: List(ParserFn(a))) -> ParserFn(a) {
  fn(input: String) {
    case parsers {
      [] -> Success(Many([]), input)
      [parser, ..other_parsers] -> {
        case parser(input) {
          Success(a, rest1) -> {
            case sequence(other_parsers)(rest1) {
              Success(Many(b), rest2) -> Success(Many([a, ..b]), rest2)
              Success(b, rest2) -> Success(Many([a, b]), rest2)
              ParseError(e) -> ParseError(e)
            }
          }
          ParseError(e) -> ParseError(e)
        }
      }
    }
  }
}

fn map(
  parser: ParserFn(a),
  f: fn(ParseResult(a, String)) -> ParseResult(a, String),
) {
  fn(input: String) {
    case parser(input) {
      Success(a, rest) -> f(Success(a, rest))
      ParseError(e) -> ParseError(e)
    }
  }
}

pub fn many(parser: ParserFn(a)) -> ParserFn(a) {
  fn(input: String) {
    case parser(input) {
      ParseError(_) -> Success(Many([]), input)
      Success(a, rest) -> {
        let assert Success(Many(b), rest) = many(parser)(rest)
        Success(Many([a, ..b]), rest)
      }
    }
  }
}

pub fn digit() {
  satisfy(char(), fn(r) {
    case r {
      Success(Char(x), rest) -> {
        case int.parse(x) {
          Ok(i) -> Success(Num(i), rest)
          Error(_) -> ParseError("not a digit")
        }
      }
      _ -> ParseError("Not a digit")
    }
  })
}

fn choice(parsers: List(fn(String) -> ParseResult(a, String))) {
  fn(input: String) {
    let r =
      parsers
      |> list.find_map(fn(parser) {
        case parser(input) {
          Success(a, rest) -> Ok(Success(a, rest))
          ParseError(e) -> Error(e)
        }
      })

    case r {
      Ok(Success(a, rest)) -> Success(a, rest)
      Ok(ParseError(e)) -> ParseError(e)
      Error(_) -> ParseError("Did not match any choices")
    }
  }
}

fn satisfy(
  parser: fn(String) -> ParseResult(a, String),
  checker: fn(ParseResult(a, String)) -> ParseResult(a, String),
) {
  fn(input: String) {
    let r = parser(input)

    checker(r)
  }
}

fn char() {
  fn(input: String) -> ParseResult(a, String) {
    case string.pop_grapheme(input) {
      Ok(#(x, rest)) -> Success(Char(x), rest)
      Error(_) -> ParseError("unexpected end of input")
    }
  }
}
