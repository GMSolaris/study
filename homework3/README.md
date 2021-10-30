Начинаем домашнюю работу №3.

1. Первым делом создадим файл .gitignore в корне проекта, чтобы исключить из коммитов все директории которые создает IDE и прочие инструменты. Все директории начинающиеся с . не попадают в коммиты.
`````*/.**/*

1. Подключаем настраиваем еще один внешний репозиторий на gitlab, прописываем ключи ssh, создаем репозиторий, подключаем его как внеший репозиторий.
```
kvazik@kvazik-matebook:/mnt/c/gmsolaris$ git remote -v
gitlab  git@gitlab.com:GMSolaris/study.git (fetch)
gitlab  git@gitlab.com:GMSolaris/study.git (push)
origin  git@github.com:GMSolaris/study.git (fetch)
origin  git@github.com:GMSolaris/study.git (push)
```