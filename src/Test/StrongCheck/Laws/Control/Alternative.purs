module Test.StrongCheck.Laws.Control.Alternative where

import Prelude

import Control.Alt ((<|>))
import Control.Alternative (class Alternative)
import Control.Monad.Eff.Console (log)
import Control.Plus (empty)

import Type.Proxy (Proxy2)

import Test.StrongCheck (SC, quickCheck')
import Test.StrongCheck.Arbitrary (class Arbitrary)
import Test.StrongCheck.Laws (A, B)

-- | - Distributivity: `(f <|> g) <*> x == (f <*> x) <|> (g <*> x)`
-- | - Annihilation: `empty <*> x = empty`
checkAlternative
  ∷ ∀ eff f
  . (Alternative f, Arbitrary (f (A → B)), Arbitrary (f A), Eq (f A), Eq (f B))
  ⇒ Proxy2 f
  → SC eff Unit
checkAlternative _ = do

  log "Checking 'Left identity' law for Alternative"
  quickCheck' 1000 distributivity

  log "Checking 'Annihilation' law for Alternative"
  quickCheck' 1000 annihilation

  where

  distributivity ∷ f (A → B) → f (A → B) → f A → Boolean
  distributivity f g x = ((f <|> g) <*> x) == ((f <*> x) <|> (g <*> x))

  annihilation ∷ f A → Boolean
  annihilation x = empty <*> x == empty ∷ f A
