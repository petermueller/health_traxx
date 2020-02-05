## TODO

- [x] add ecto starter bits
- [ ] add poll worker
- [ ] determine/add scheduling of polls
- [ ] add Protocol for requesting client data
  - [ ] add implementations for each payor data struct
- [ ] add `external_payor_id` to `payor_procedures`


## Nice to haves
- [ ] ability to load/reload procedures to poll w/o restarting the app
- [ ] supervision strategies that don't restart the world, or cause a thundering herd
- [ ] pooling for poll workers
  - [ ] determine how we want to pool (probably by payor, but that adds constraints to the scheduling of all payors)
