-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Optional: Create a sample table with vector column
-- Uncomment the following lines if you want a sample table

-- CREATE TABLE IF NOT EXISTS items (
--     id BIGSERIAL PRIMARY KEY,
--     content TEXT,
--     embedding vector(1536)  -- OpenAI ada-002 dimension
-- );

-- CREATE INDEX IF NOT EXISTS items_embedding_idx ON items 
--     USING ivfflat (embedding vector_cosine_ops)
--     WITH (lists = 100);
