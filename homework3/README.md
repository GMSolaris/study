Начинаем домашнюю работу №3.1

1. Первым делом создадим файл .gitignore в корне проекта, чтобы исключить из коммитов все директории которые создает IDE и прочие инструменты. Все директории начинающиеся с . не попадают в коммиты.


2. Подключаем настраиваем еще один внешний репозиторий на gitlab, прописываем ключи ssh, создаем репозиторий, подключаем его как внеший репозиторий.
```
kvazik@kvazik-matebook:/mnt/c/gmsolaris$ git remote -v
gitlab  git@gitlab.com:GMSolaris/study.git (fetch)
gitlab  git@gitlab.com:GMSolaris/study.git (push)
origin  git@github.com:GMSolaris/study.git (fetch)
origin  git@github.com:GMSolaris/study.git (push)
```

3. Подключаем настраиваем еще один внешний репозиторий на bitbucket, прописываем ключи ssh, создаем репозиторий, подключаем его как внеший репозиторий.
```
kvazik@kvazik-matebook:/mnt/c/gmsolaris/study$ git remote -v
bb      git@bitbucket.org:gmsolaris/study.git (fetch)
bb      git@bitbucket.org:gmsolaris/study.git (push)
gitlab  git@gitlab.com:GMSolaris/study.git (fetch)
gitlab  git@gitlab.com:GMSolaris/study.git (push)
origin  git@github.com:GMsolaris/study.git (fetch)
origin  git@github.com:GMsolaris/study.git (push)
```
4. Пушим наш проект со всеми коммитами на все три внешних репозитория

№3.2

1. Добавляем два тега к коммиту и пушим в три upstream.

```
kvazik@kvazik-matebook:/mnt/c/gmsolaris/study$ git tag v0.0 -m "tag 0"
kvazik@kvazik-matebook:/mnt/c/gmsolaris/study$ git tag
v0.0
kvazik@kvazik-matebook:/mnt/c/gmsolaris/study$ git tag -a v0.1 -m "tag 1"
kvazik@kvazik-matebook:/mnt/c/gmsolaris/study$ git tag
v0.0
v0.1
```
№3.3
Переходим на старый коммит, создаем от него ветку fix, вносим изменения в файл, пушим новую ветку с изменениями.

№3.4 Пробуем поработать с IDE и git, подключаем IDE к git, делаем из IDE пару тестовых коммитов.
пришлось прописать еще и ключи из windows gitbash, так как по умолчанию Pycharm под win работает с консолью от win, и не использует установленный в wls debian.
