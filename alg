
import numpy as np
import random
m = int(input('Размер карты: '))# даем размер карте m на m


# дальше следует проверка где если m четное то мы начинаем со сдвигом, а если m нечетное то начинаем из центра
if m % 2 == 0:
    x_0 = (m//2)-1
    y_0 = (m//2)-1
else:
    x_0 = m // 2
    y_0 = m // 2


LIST = [[0, 0], [10, 5], [10, 6], [6, 9], [7, 10], [6, 10], [2, 6], [2, 7]] # список препятствий
moon = [[0] * m for i in range(m)]# клетки всего поля: 0 - клетка, про которую нам ничего не известно, 1 - клетка, на которой мы побывали, -1 - известное нам препятствие
x = x_0
y = y_0
# дальше следует работа с границами. Мы спрашиваем про границы у пользователя
# например если границы нам нужно расположить по границам карты
# то просто пишем что правый ряд значение m
# левый значение - 1
# нижний значение  - m
# верхний - 1
pr = int(input('Введите какой ряд справа будет границей: '))
lr = int(input('Введите какой ряд слева будет границей: '))
nr = int(input('Введите какой нижний ряд будет границей: '))
vr = int(input('Введите какой верхний ряд справа будет границей: '))

# random2 это массив, заполненный рандомными числами, якобы зонами, где только зоня со значением 4 нам будут интересны и потом помечены на карте
random2 = list()
for i in range(0, m):
    random2.append([int(random.randint(0, 9)) for i in range(1, m+1)])
print(np.resize(random2, (m, m)))

# массив zone это массив где: 1.хранятся наши границы 2.Зонам из массива random2 дается значение
# если зона со значением 4 то она помечается на карте как 1, а остальные как 0
zone = list()
for i in range(0, m):
    zone.append([int(0) for i in range(1, m+1)])


# дальше идет заполнение границ в массив zone
a = 0
b = pr - 1
for i in range(m):
    zone[a][b] = 8
    a += 1
a = vr - 1
b = 0
for i in range(m):
    zone[a][b] = 8
    b += 1
a = 0
b = lr - 1
for i in range(m):
    zone[a][b] = 8
    a += 1
a = nr - 1
b = 0
for i in range(m):
    zone[a][b] = 8
    b += 1




# эти переменные, Оля, ты знаешь
sign = 0
o = 'right'
r = 1
d = 1
d1 = 1
d_x = 0
d_y = 0
p = 0
q = 0
# дальше идет некая проверка(я уже говорил) что зона 4 помечается как 1, а остальные как 0
def prov():

    try:
        if random2[x][y] == 4:
            zone[x][y] = 1
        else:
            zone[x][y] = 0
    except:
        pass
# функция передвежения
def go_forward():
    global x, y
    if o == 'up':
        y -= 1
    elif o == 'down':
        y += 1
    elif o == 'right':
        x += 1
    else:
        x -= 1


def moving():
    global x, y, moon
    print(x, y)
    moon[x][y] = 1

# дальше функции обхода
def detour_up():
    global x, y, d_x, d_y
    while [x + 1, y] in LIST and [x, y - 1] not in LIST:
        y -= 1
        d_y -= 1
        moving()


def detour_right():
    global x, y, d_x, d_y
    while [x, y + 1] in LIST and [x + 1, y] not in LIST:
        x += 1
        d_x += 1
        moving()


def detour_down():
    global x, y, d_x, d_y
    while [x - 1, y] in LIST and [x, y + 1] not in LIST:
        y += 1
        d_y += 1
        moving()


def detour_left():
    global x, y, d_x, d_y
    while [x, y - 1] in LIST and [x - 1, y] not in LIST:
        x -= 1
        d_x -= 1
        moving()


def detour():
    global x, y, o, r, d, d1, d_x, d_y, moon
    if o == 'right':
        print('d_right')
        moving()
        if [x, y - 1] not in LIST:
            detour_up()
        elif [x + 1, y] not in LIST:
            detour_right()
        elif [x, y + 1] not in LIST:
            detour_down()
        d += d_x
        d -= 1
    elif o == 'left':
        print('d_left')
        if [x, y + 1] not in LIST:
            detour_down()
        elif [x - 1, y] not in LIST:
            detour_left()
        elif [x, y - 1] not in LIST:
            detour_up()
        d += d_x
        d -= 1
    elif o == 'up':
        print('d_up')
        if [x - 1, y] not in LIST:
            detour_left()
        elif [x, y - 1] not in LIST:
            detour_up()
        elif [x + 1, y] not in LIST:
            detour_right()
        d += d_y
        d -= 1
    else:
        print('d_down')
        if [x + 1, y] not in LIST:
            detour_right()
        elif [x, y + 1] not in LIST:
            detour_down()
        elif [x - 1, y] not in LIST:
            detour_left()
        d += d_y
        d -= 1

# это переменная которая помогает остановить наш алгоритм обхода когда мы наступаем на границу
# пока мы не наступили на границу она имеет значение 1
sch = 1

# основная часть алгоритма, я покажу и расскажу мои изменения от старого алгоритма

def key():
    global x, y, o, r, d, d1, d_x, d_y, p, q, moon, sch
    while sch == 1:
        if o == 'right':
            if d_y < 0:
                p = y
                q = x
            while d_y < 0:
                if [x, y + 1] in LIST:
                    go_forward()
                    d += 1
                    moving()
                    # вот эти 3 сторички снизу
                    # после кажжого шага я проверяю зону, не является ли она границей, если да то меняю значение
                    # переменной sch и алгоритм останавливается
                    if zone[x][y] == 8:
                        sch = 2
                        break
                    # дальше вызываю функцию проверки интересных зон
                    prov()
                else:
                    if x == q and y == p:
                        go_forward()
                        d += 1
                        moving()

                        if zone[x][y] == 8:
                            sch = 2
                            break
                        prov()
                    else:
                        y += 1
                        d_y += 1
                        moving()
                        if zone[x][y] == 8:
                            sch = 2
                        prov()
            if d_y == 0:
                d_x = 0
            if [x + 1, y] in LIST:
                moon[x + 1][y] = -1
                detour()
            else:
                go_forward()
                moving()
                if zone[x][y] == 8:
                    sch = 2
                prov()
                moon[x][y] = 1
        elif o == 'left':
            if d_y > 0:
                p = y
                q = x
            while d_y > 0:
                if [x, y - 1] in LIST:
                    go_forward()
                    d += 1
                    moving()
                    if zone[x][y] == 8:
                        sch = 2
                        break
                    prov()
                else:
                    if x == q and y == p:
                        go_forward()
                        d += 1
                        moving()
                        if zone[x][y] == 8:
                            sch = 2
                            break
                        prov()
                    else:
                        y -= 1
                        d_y -= 1
                        moving()
                        if zone[x][y] == 8:
                            sch = 2
                            break
                        prov()
            if d_y == 0:
                d_x = 0
            if [x - 1, y] in LIST:
                moon[x - 1][y] = -1
                detour()
            else:
                go_forward()
                moving()
                if zone[x][y] == 8:
                    sch = 2
                    break
                prov()
                moon[x][y] = 1
        elif o == 'up':
            if d_x < 0:
                p = y
                q = x
            while d_x < 0:
                if [x + 1, y] in LIST:
                    go_forward()
                    d += 1
                    moving()
                    if zone[x][y] == 8:
                        sch = 2
                        break
                    prov()
                else:
                    if x == q and y == p:
                        go_forward()
                        d += 1
                        moving()
                        if zone[x][y] == 8:
                            sch = 2
                            break
                        prov()
                    else:
                        x += 1
                        d_x += 1
            if d_y == 0:
                d_x = 0
            if [x, y - 1] in LIST:
                moon[x][y - 1] = -1
                detour()

            else:
                go_forward()
                moving()
                if zone[x][y] == 8:
                    sch = 2
                    break
                prov()
                moon[x][y] = 1
        else:
            if d_x > 0:
                p = y
                q = x
            while d_x > 0:
                if [x - 1, y] in LIST:
                    go_forward()
                    d += 1
                    moving()
                    if zone[x][y] == 8:
                        sch = 2
                        break
                    prov()
                else:
                    if x == q and y == p:
                        go_forward()
                        d += 1
                        moving()
                        if zone[x][y] == 8:
                            sch = 2
                            break
                        prov()
                    else:
                        x -= 1
                        d_x -= 1
                        moving()
                        if zone[x][y] == 8:
                            sch = 2
                            break
                        prov()
            if d_y == 0:
                d_x = 0
            if [x, y + 1] in LIST:
                moon[x][y + 1] = -1
                detour()
                moving()
                prov()
            else:
                go_forward()
                moving()
                if zone[x][y] == 8:
                    sch = 2
                    break
                prov()
                moon[x][y] = 1



        if sign == 0:
            if r == d:
                if o == 'right':
                    o = 'down'
                elif o == 'down':
                    o = 'left'
                elif o == 'left':
                    o = 'up'
                else:
                    o = 'right'
                if d1 == 0:
                    r += 1
                    d1 = 1
                else:
                    d1 = 0
                d = 1
            else:
                d += 1
    print('ПРЕПЯТСТВиЯ/ЗОНЫ ГДЕ МЫ БЫЛИ/ЗОНЫ ПРО КОТОРЫЕ НАМ НИЧЕГО НЕ ИЗВЕСТНО: ')
    print(np.resize(moon, (m, m)))

    print('Интересные зоны: ')
    print(np.resize(zone, (m, m)))


schet = 1 # протосто счетчик который остановит цикл  снизу

razmer = m*m # размер нашей карты
# дальше идет цикл который m*m раз запускает основную функцию
while schet != razmer and sch == 1:
    schet += 1
    key()
