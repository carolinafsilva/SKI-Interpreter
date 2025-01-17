module Main where
import Lexer
import Parser
import Ast

stringOfTerm :: Term -> String
stringOfTerm t = case t of
  S -> "S"
  K -> "K"
  I -> "I"
  Var x -> x
  App t (App t1 t2) -> stringOfTerm t ++ " (" ++ stringOfTerm (App t1 t2) ++ ")"
  App t1 t2 -> stringOfTerm t1 ++ " " ++ stringOfTerm t2

eval :: Term -> Term
eval t = case t of
  Grp t   -> eval t
  App I x -> eval x
  App (App K x) _ -> eval x
  App (App (App S x) y) z -> eval (App (eval (App x z)) (eval (App y z)))
  App t1 t2 ->
    let t1' = eval t1
     in let t2' = eval t2
         in if t1' /= t1 || t2' /= t2
              then eval (App t1' t2')
              else App t1 t2
  t -> t

main :: IO ()
main = do
  s <- getContents
  let ast = parse (scanTokens s)
  print ast
  print (eval ast)
  print (stringOfTerm (eval ast))
