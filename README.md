# Maps.epf

Приклад інтеграції 1С з сервісами геоданих.

Виконує наступні функції:

* Відображення карти з інтерактивним вибором координат поточної шляхової точки
* Геокодинг (адреса в координати)
* Зворотній геокодинг (координати в адресу)
* Планування маршруту з розрахунком орієнованого часу та відстані
* Оптимізація маршруту

# Підтримувані платформи

Протестовано на 8.3 від 8.3.11, на Windows 7 (з встановленим Internet Explorer 11), 10, та 11
**Поки підтримуються тільки звичайні форми**

# Build

1. Створити файл .env з наступним вмістом:
    ```
    1C_HOME=C:\Program Files[ (x86)]\1cv8\x.y.zz.wwww
    ```
2. Запустити файл build.ps1
3. Файл обробки .epf має з'явитися в папці `build`

# Використовувані технології

Для відображення карт використовуєтья [leaflet.js](https://github.com/Leaflet/Leaflet), та наступні плагіни:
* [Leaflet.markercluster](https://github.com/Leaflet/Leaflet.markercluster)
* [Leaflet.GeometryUtil](https://github.com/makinacorpus/Leaflet.GeometryUtil)
* [leaflet-arrowheads](https://github.com/slutske22/leaflet-arrowheads) ([Форк](https://github.com/huma-v/leaflet-arrowheads-es5))
* [Leaflet Polyline Offset](https://github.com/bbecquet/Leaflet.PolylineOffset) ([Форк](https://github.com/higaa/Leaflet.PolylineOffset))

Також використовуються сторонні API на яких можуть бути окремі обмеження використання:
* [IPWHOIS.IO](https://ipwhois.io) - не підтримує безкоштовне використання в коммерційних цілях
* [OpenStreetMap](www.openstreetmap.org)
* [Nominatim](https://nominatim.org/)
* [OSRM](https://project-osrm.org/)

Якщо ви збираєтесь використовувати цю обробку в роботі, рекомендується закоментувати виклик ipwhois
і перенаправити OSM, Nominatim, OSRM на локально розгорнуті сервіси