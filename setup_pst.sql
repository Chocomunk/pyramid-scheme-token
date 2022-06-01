-- Notes:
--      Base price is the fundamental price of the token before owner royalties
--      The "buy-in-price" the the price owed to every owner on each purchase
--              For N existing owners, the price should be `base_price + N * buy_in`
--      We (the developers) are always the first owner
--      Any user can buy a token again to recieve additional royalties

-- Tables:
-- Tokens table: token_ticker, img_path, base_price, buy_in_price, owner_count
-- (maybe) Users table: username, password (base64 encoded), balance, is_admin
-- (maybe) Transactions: username, token_ticker

-- Is there a better way of keeping track of transactions so that seeing all of
--  a token's transactions is fast?
