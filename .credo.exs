%{
  configs: [
    %{
      name: "default",
      strict: true,
      checks: [
        {Credo.Check.Design.TagTODO, false}
      ]
    }
  ]
}
