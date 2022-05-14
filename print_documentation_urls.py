import pkg_resources


def p(package, type_, url):
    print(";".join((package.strip(), type_.strip(), url.strip())))


for package in pkg_resources.working_set:
    if not package.has_metadata("METADATA"):
        continue

    for line in package.get_metadata_lines("METADATA"):
        if line.startswith("Home-page: "):
            p(package.key, "Home-page", line[11:])
        elif line.startswith("Project-URL: "):
            type_, url = line[13:].split(",")
            p(package.key, type_, url)
