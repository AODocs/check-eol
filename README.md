
# GitHub action to check end of line (EOL) against .gitattributes rules

GitHub Action to add to a workflow, to validate rules of EOL defined in .gitattributes files.


### Result : Errors

```bash
check EOL in: .
Found file .gitignore with crlf endings but expected lf.
Found file src/test_sample_message.eml with lf endings but expected crlf.
Found file src/text_bad.txt with crlf endings but expected lf.
```

### Result : Warnings

```bash
check EOL in: .
No EOL rule defined for README.md
```

### Result : Success

```bash
check EOL in: .
No files with EOL errors found.
```


## Configuration

```yml
name: Check EOL

on: push

jobs:
  my-workflow:
    name: Example workflow using the Check EOL
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository contents
        uses: actions/checkout@v1

      - name: Use this action to check EOL 
        uses: easylo/check-eol@v1
        with: # omit this mapping to use default path
          path: ./a-custom-path
```