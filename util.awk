function randint(n) {
  return int(n * rand())
}

BEGIN {
  srand()
  results["returncode"] = 0
  results["followup"] = ""
}
