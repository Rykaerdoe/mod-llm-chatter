-- Dedicated log of instant-path (pre-cached combat/state/spell reaction)
-- bot chat lines, for external tools that want to react to EVERY party
-- line, not just the ones that go through llm_chatter_messages.
--
-- Instant-path deliveries (SendPartyMessageInstant() in
-- LLMChatterShared.cpp) skip llm_chatter_messages entirely, since there's
-- no LLM round-trip to queue for an already-templated/pre-cached
-- reaction. This table is the ONLY thing written by that code path (see
-- the logForTts parameter on SendPartyMessageInstant) - unlike
-- llm_group_chat_history, which is ALSO written from dozens of other
-- places in the Python bridge for regular (already-queued) messages, and
-- is therefore NOT safe to poll alongside llm_chatter_messages without
-- double-counting every regular line.

CREATE TABLE IF NOT EXISTS `llm_chatter_instant_log` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `bot_guid` INT UNSIGNED NOT NULL,
    `bot_name` VARCHAR(64) NOT NULL,
    `group_id` INT UNSIGNED DEFAULT NULL,
    `message` TEXT NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
