from git import Repo

repo = Repo('.')
print(repo.heads.master)
