-- Notes:
--      Base price is the fundamental price of the token before owner royalties
--      The "buy-in-price" in the price owed to every previous owner on each new purchase
--          On each purchase the **current owner** gains `base_price + buy_in`
--              then the ownership is transferred to the buyer.
--          All previous owners only recieve `buy_in` on each new purchase.
--          For N existing owners, the price should be `base_price + N * buy_in`
--      We (the developers) are always the first owner (so we recieve royalties)
--      Any user can buy a token again to recieve additional royalties

-- Tables:
-- Tokens table: token_ticker, img_path, base_price, buy_in_price, owner_count
-- (maybe) Users table: username, password (base64 encoded), balance, is_admin
-- (maybe) Purchases table: username, token_ticker

-- Is there a better way of keeping track of transactions so that seeing all of
--  a token's transactions is fast?
