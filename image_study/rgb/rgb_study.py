import numpy as np
from PIL import Image
import colorsys


class Rainbow:
    RED = (255, 0, 0)
    ORANGE = (255, 165, 0)
    YELLOW = (255, 255, 0)
    GREEN = (0, 255, 0)
    BLUE = (0, 0, 255)
    INDIGO = (75, 0, 130)
    VIOLET = (238, 130, 238)

    def rainbow_colors():
        return [
            Rainbow.RED,
            Rainbow.ORANGE,
            Rainbow.YELLOW,
            Rainbow.GREEN,
            Rainbow.BLUE,
            Rainbow.INDIGO,
            Rainbow.VIOLET
        ]


if __name__ == "__main__":
    height = 210 # 색상을 7개로 나누기 위해 210으로 설정
    width = 210 # height와 같은 값으로 설정
    row_height = height // 7 # 색상을 7개로 나누기 위해 210을 7로 나눔

    img_array = np.zeros((height, width, 3), dtype=np.uint8) # rgb를 사용하므로 3차원 배열 생성

    rainbow_colors = Rainbow.rainbow_colors() # 색상 리스트 생성

    for i, color in enumerate(rainbow_colors): # 색상 리스트를 순회하며 각 색상을 추가
        start_y = i * row_height # 색상을 7개로 나누기 위해 210을 7로 나눔
        end_y = start_y + row_height # 색상을 7개로 나누기 위해 210을 7로 나눔
        for y in range(start_y, end_y):
            img_array[y] = [color] * width

    Image.fromarray(img_array, 'RGB').save("rainbow_210x210.png")

