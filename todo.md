## TODO

- [x] add ecto starter bits
- [x] add poll worker
- [x] persist from a single poll
- [ ] determine/add scheduling of polls
- [x] add `external_payor_id` to `payor_procedures`
- [ ] add `procedure_endpoint` field to `payors`
  - for use with `PayorClient` (also tbd)


## Nice to haves
- [ ] ability to load/reload procedures to poll w/o restarting the app
- [ ] supervision strategies that don't restart the world, or cause a thundering herd
- [ ] pooling for poll workers
  - [ ] determine how we want to pool (potentially by payor in case their APIs suck, but that adds constraints to the scheduling of all payors)
- [ ] swap default `timestamps()` to be `utc_datetime_usec`

## Worth investigating (or things I wish I'd have done)
- [ ] dropping the `payors` table and using an enum instead
  - originally what I was considering doing before I started making tables
  - has the negative that postgres makes it difficult to drop enum values
- [ ] change `reimbursement_amounts` to join to a new table `reimbursement_intervals`
  - `reimbursement_amounts.replaced_at` goes away
  - con: if only one amount is updated it just moves a duplicated-"amount"-record problem into a new join table
  - probably needs more clarification on why "intervals" are necessary (didn't have time :-/ )
