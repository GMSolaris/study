1. Создали файл, проверили статус git status. 
	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git status
	On branch master
	Your branch is up to date with 'origin/master'.

	Untracked files:
	(use "git add <file>..." to include in what will be committed)
			homework2.md

	nothing added to commit but untracked files present (use "git add" to track)

2. Добавили в файл изменения. Добавили файл в состояние staged. git add *
Проверяем вывод git diff --staged
	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git diff --staged
	diff --git a/homework2.md b/homework2.md
	new file mode 100644
	index 0000000..cba7c2f
	--- /dev/null
	+++ b/homework2.md
	@@ -0,0 +1,12 @@
	+1. Создали файл, проверили статус git status. ^M
	+kvazik@myagkikh:/mnt/c/gmsolaris/study$ git status^M
	+On branch master^M
	+Your branch is up to date with 'origin/master'.^M
	+^M
	+Untracked files:^M
	+  (use "git add <file>..." to include in what will be committed)^M
	+        homework2.md^M
	+^M
	+nothing added to commit but untracked files present (use "git add" to track)^M
	+^M
	+2. Добавили в файл изменения. Проверим вывод git status
	\ No newline at end of file

3. Делаем первый коммит. git commit -m 'First commit'
	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git commit -m 'First commit'
	[master e192339] First commit
	Committer: Alexander Myagkikh <kvazik@myagkikh.mxgroup.loc>

	1 file changed, 12 insertions(+)
	create mode 100644 homework2.md
	
4. Создаем файл .gitignore, добавляем его в коммит. 
	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git add .gitignore
	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git status
	On branch master
	Your branch is ahead of 'origin/master' by 1 commit.
	(use "git push" to publish your local commits)

	Changes to be committed:
	(use "git restore --staged <file>..." to unstage)
			new file:   .gitignore

	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git commit -m 'Added .gitignore'
	[master 72f6cd2] Added .gitignore
	Committer: Alexander Myagkikh <kvazik@myagkikh.mxgroup.loc>
	
	1 file changed, 0 insertions(+), 0 deletions(-)
	create mode 100644 .gitignore
	
5. Добавляем папку terraform, добавялем в него дефолтный .gitignore и readme с описанием файлов, которые будут проигнорированы. Делаем коммит. 
	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git add *
	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git status
	On branch master
	Your branch is ahead of 'origin/master' by 2 commits.
	(use "git push" to publish your local commits)

	Changes to be committed:
	(use "git restore --staged <file>..." to unstage)
			new file:   terraform/.gitignore
			new file:   terraform/readme.md

	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git commit -m 'Added terraform gitignore + readme with description'
	[master 71ee4f8] Added terraform gitignore + readme with description


	2 files changed, 45 insertions(+)
	create mode 100644 terraform/.gitignore
	create mode 100644 terraform/readme.md