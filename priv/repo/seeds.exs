alias HealthTraxx.Repo
alias HealthTraxx.Reimbursements
alias HealthTraxx.Reimbursements.{Payor, Procedure}

# Make Procedures

[
  hip_replacement,
  liver_transplant,
  lobotomy,
  arm_amputation,
  appendix_removal,
  triple_bypass
] =
  [
    "Hip Replacement",
    "Liver Transplant",
    "Lobotomy",
    "Arm Amputation",
    "Appendix Removal",
    "Triple Bypass"
  ]
  |> Enum.map(fn name ->
    Repo.insert!(%Procedure{name: name})
  end)

# Make Payors

[
  pumana,
  dcds,
  sigma
] =
  [
    "Pumana",
    "DCDS",
    "Sigma"
  ]
  |> Enum.map(fn name ->
    Repo.insert!(%Payor{name: name})
  end)

# Connect Procedure to Payors that reimburse for them
# TODO determine structure so that procedures can "stop" being checked for reimbursement, but won't have to delete join record
#   Probably just a `reimbursable = false` or something, or maybe a separate table. Just wanna get it working first

procedures_with_payors_and_initial_values = [
  {hip_replacement,
   [
     {pumana, %{id: "0e346ba3-2b0c-463d-a3d0-91a5d32a0ade", reimbursement_amount: "39.99"}},
     {dcds, %{id: "hip-replacement-r-side", reimbursement_amount: "41.99"}},
     {sigma, %{id: "1009", reimbursement_amount: "40.19"}}
   ]},
  {liver_transplant,
   [
     {pumana, %{id: "897d9271-370b-4a29-b4bb-1944cf0407af", reimbursement_amount: "452.65"}},
     {dcds, %{id: "liver-transplant-no-complications", reimbursement_amount: nil}},
     {sigma, %{id: "6482", reimbursement_amount: "443.21"}}
   ]},
  {lobotomy,
   [
     {pumana, %{id: "cccc7d8f-ed9a-4729-b595-c4fd405ee66b", reimbursement_amount: nil}},
     {dcds, %{id: "lobotomy", reimbursement_amount: "0.56"}},
     {sigma, %{id: "1375", reimbursement_amount: "1.06"}}
   ]},
  {arm_amputation,
   [
     {pumana, %{id: "f94ff092-acc1-46c2-86de-300fdeec9b83", reimbursement_amount: "1.57"}},
     {dcds, %{id: "amputation-upper-limb-r-side", reimbursement_amount: "3.78"}},
     {sigma, %{id: "8424", reimbursement_amount: nil}}
   ]},
  {appendix_removal,
   [
     {pumana, %{id: "2b392b45-7d20-42b2-a0ee-9ed5dac95cdc", reimbursement_amount: "26.98"}},
     {dcds, %{id: "appendicitis-recommendation", reimbursement_amount: "32.22"}},
     {sigma, %{id: "5971", reimbursement_amount: "29.87"}}
   ]},
  {triple_bypass,
   [
     {pumana, %{id: "9bf55346-fa25-45f1-a099-66ee41cf2188", reimbursement_amount: "111.68"}},
     {dcds, %{id: "heart-surgery-bypass-x-3", reimbursement_amount: "105.69"}},
     {sigma, %{id: "3246", reimbursement_amount: "132.54"}}
   ]}
]

# Dislike this, but it makes each record a separate transaction which I prefer when seeding

procedures_with_payors_and_initial_values
|> Enum.each(fn {procedure, payor_initial_values} ->
  Enum.each(payor_initial_values, fn {payor, initial_value} ->
    payor_procedure =
      Reimbursements.create_payor_procedure!(%{
        procedure_id: procedure.id,
        payor_id: payor.id,
        external_id: initial_value.id,
        check_reimbursability: !!initial_value.reimbursement_amount
      })

    amount =
      if initial_value.reimbursement_amount do
        initial_value.reimbursement_amount
      else
        0
      end

    %{payor_procedure_id: payor_procedure.id, amount: amount}
    |> Reimbursements.create_reimbursement_amount!()
  end)
end)
