
-- =====================================================
-- VoteSphere - Initial Database Schema
-- Organisation: Veltara Technologies
-- Database: PostgreSQL
-- =====================================================

-- 1. USERS
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'voter'
        CHECK (role IN ('voter', 'admin')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX users_email_unique
ON users (LOWER(email));


-- 2. ELECTIONS
CREATE TABLE elections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'draft'
        CHECK (
            status IN ('draft', 'scheduled', 'active', 'completed')
        ),
    created_by UUID NOT NULL REFERENCES users(id)
        ON DELETE RESTRICT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT valid_election_period
        CHECK (end_time > start_time)
);


-- 3. CANDIDATES
CREATE TABLE candidates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    election_id UUID NOT NULL REFERENCES elections(id)
        ON DELETE RESTRICT,
    full_name VARCHAR(150) NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Required for the composite foreign key in votes.
    CONSTRAINT unique_election_candidate
        UNIQUE (election_id, id)
);


-- 4. ELECTION VOTERS
CREATE TABLE election_voters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    election_id UUID NOT NULL REFERENCES elections(id)
        ON DELETE RESTRICT,
    user_id UUID NOT NULL REFERENCES users(id)
        ON DELETE RESTRICT,
    has_voted BOOLEAN NOT NULL DEFAULT FALSE,
    voted_at TIMESTAMPTZ,

    CONSTRAINT unique_election_voter
        UNIQUE (election_id, user_id),

    CONSTRAINT valid_voting_status
        CHECK (
            (has_voted = FALSE AND voted_at IS NULL)
            OR
            (has_voted = TRUE AND voted_at IS NOT NULL)
        ),

    -- Required for the composite foreign key in votes.
    CONSTRAINT unique_eligibility_record
        UNIQUE (election_id, user_id, id)
);


-- 5. VOTES
CREATE TABLE votes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    election_id UUID NOT NULL,
    voter_id UUID NOT NULL,
    candidate_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- One vote per eligible voter per election.
    CONSTRAINT prevent_duplicate_votes
        UNIQUE (election_id, voter_id),

    -- The voter must have an eligibility record.
    CONSTRAINT vote_requires_eligibility
        FOREIGN KEY (election_id, voter_id)
        REFERENCES election_voters (election_id, user_id)
        ON DELETE RESTRICT,

    -- The candidate must belong to the same election.
    CONSTRAINT candidate_must_belong_to_election
        FOREIGN KEY (election_id, candidate_id)
        REFERENCES candidates (election_id, id)
        ON DELETE RESTRICT
);


-- 6. INDEXES
CREATE INDEX idx_candidates_election
ON candidates (election_id);

CREATE INDEX idx_election_voters_user
ON election_voters (user_id);

CREATE INDEX idx_votes_election
ON votes (election_id);

CREATE INDEX idx_votes_candidate
ON votes (election_id, candidate_id);


-- =====================================================
-- END OF INITIAL SCHEMA
-- =====================================================
