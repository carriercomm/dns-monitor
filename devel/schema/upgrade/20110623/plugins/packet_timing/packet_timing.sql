-- Timing table
CREATE TABLE packet_timing
(
  id bigserial NOT NULL,
  conversation_id bigint,
  query_id bigint,
  response_id bigint,
  difference numeric(11,6) NOT NULL,
  CONSTRAINT packet_timing_pki PRIMARY KEY (id),
  CONSTRAINT packet_timing_fk_conversation FOREIGN KEY (conversation_id)
      REFERENCES conversation (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT packet_timing_fk_query FOREIGN KEY (query_id)
      REFERENCES packet_query (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT packet_timing_fk_response FOREIGN KEY (response_id)
      REFERENCES packet_response (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);

