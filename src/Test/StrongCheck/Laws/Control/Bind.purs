module Test.StrongCheck.Laws.Control.Bind where

import Prelude

import Control.Monad.Eff.Console (log)

import Type.Proxy (Proxy2)

import Test.StrongCheck (SC, quickCheck')
import Test.StrongCheck.Arbitrary (class Arbitrary)
import Test.StrongCheck.Laws (A)

-- | - Associativity: `(x >>= f) >>= g = x >>= (\k → f k >>= g)`
checkBind
  ∷ ∀ eff m
  . (Bind m, Arbitrary (m A), Eq (m A))
  ⇒ Proxy2 m
  → SC eff Unit
checkBind _ = do

  log "Checking 'Associativity' law for Bind"
  quickCheck' 1000 associativity

  where

  associativity ∷ m A → (A → m A) → (A → m A) → Boolean
  associativity m f g = ((m >>= f) >>= g) == (m >>= (\x → f x >>= g))
