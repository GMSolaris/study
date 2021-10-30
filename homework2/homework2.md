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
	
6. Создаем пару файлов и коммитим их для экспериментов с добавлением\удалением файлов из репозитория.
	
	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git add *
	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git status
	On branch master
	Your branch is up to date with 'origin/master'.

	Changes to be committed:
	  (use "git restore --staged <file>..." to unstage)
			new file:   will_be_deleted.txt
			new file:   will_be_moved.txt

	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git commit
	[master def2fe4] Added two files do delete move
	
	 2 files changed, 0 insertions(+), 0 deletions(-)
	 create mode 100644 will_be_deleted.txt
	 create mode 100644 will_be_moved.txt


7. Удаляем файл will_be_deleted, переименовываем файл will_be_moved. Добавляем все в коммит.
	
	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git rm will_be_deleted.txt
	rm 'will_be_deleted.txt'
	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git status
	On branch master
	Your branch is ahead of 'origin/master' by 1 commit.
	(use "git push" to publish your local commits)

		Changes to be committed:
	(use "git restore --staged <file>..." to unstage)
			deleted:    will_be_deleted.txt

		Changes not staged for commit:
	(use "git add/rm <file>..." to update what will be committed)
	(use "git restore <file>..." to discard changes in working directory)
			deleted:    will_be_moved.txt

		Untracked files:
	(use "git add <file>..." to include in what will be committed)
			has_been_moved.txt
	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git rm will_be_moved.txt
	rm 'will_be_moved.txt'
	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git add *
	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git status
		On branch master
	Your branch is ahead of 'origin/master' by 1 commit.
	(use "git push" to publish your local commits)

	Changes to be committed:
	(use "git restore --staged <file>..." to unstage)
			renamed:    will_be_deleted.txt -> has_been_moved.txt
			deleted:    will_be_moved.txt
			
8. Проверяем что мы наделали через git log  

	kvazik@myagkikh:/mnt/c/gmsolaris/study$ git log >> git.log
	commit 214a5d1d2b1a5ec682083fda78187f9a1f455ec0 (HEAD -> master)
	Author: Alexander Myagkikh <kvazik@myagkikh.mxgroup.loc>
	Date:   Tue Oct 26 11:59:03 2021 +1000

		Moved and deleted

	commit 95739d7eaea2e54be9f93822bc8689ab66ddaeaf
	Author: Alexander Myagkikh <kvazik@myagkikh.mxgroup.loc>
	Date:   Tue Oct 26 11:52:21 2021 +1000

		Prepare to delete and move

	commit 71ee4f8611b5ac37b6c79809c5ea476009c7f32a (origin/master, origin/HEAD)
	Author: Alexander Myagkikh <kvazik@myagkikh.mxgroup.loc>
	Date:   Tue Oct 26 11:46:45 2021 +1000

		Added terraform gitignore + readme with description

	commit 72f6cd29d323c41471a37d53d4819e31eb4357eb
	Author: Alexander Myagkikh <kvazik@myagkikh.mxgroup.loc>
	Date:   Tue Oct 26 11:33:09 2021 +1000

		Added .gitignore

	commit e192339a6b6d9925741d1db8f0bdefa58169b02c
	Author: Alexander Myagkikh <kvazik@myagkikh.mxgroup.loc>
	Date:   Tue Oct 26 11:27:52 2021 +1000

		First commit
		
9. Пушим все что наделали в репозиторий. 