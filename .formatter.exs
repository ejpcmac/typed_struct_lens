[
  inputs: [
    "{mix,.iex,.formatter,.credo}.exs",
    "{config,lib,rel,test}/**/*.{ex,exs}"
  ],
  line_length: 80,
  import_deps: [:typed_struct, :lens]
]
