

from PIL import Image  # Pillow 라이브러리에서 Image 모듈 불러오기 (이미지 로드/저장/처리용)
import numpy as np     # Numpy 라이브러리 불러오기 (배열 변환 및 이미지 데이터 처리용)

def apply_mosaic(image_path, output_path, scale=0.05):
    img = Image.open(image_path)
    arr = np.array(img)

    # h = 세로, w = 가로, _c = 채널 rgb는 3채널
    h, w, _c = arr.shape

    small = Image.fromarray(arr).resize(
        (int(w*scale), int(h*scale)),
    )
    # 2) 축소한 이미지를 원래 크기로 확대 (픽셀 블록화 효과)
    mosaic_img = small.resize((w, h), Image.NEAREST)

    # 처리한 이미지 저장
    mosaic_img.save(output_path)
    print(f"Mosaic saved to {output_path}")  # 저장 완료 메시지 출력

class ImageMosaic:
    def __init__(self, image_path, output_path, scale=0.05):
        self.image_path = image_path
        self.output_path = output_path
        self.scale = scale

    def apply_mosaic(self):
        img = Image.open(self.image_path)
        arr = np.array(img)
        h, w, _c = arr.shape

        # 사진을 축소합니다.
        downscaled_image = Image.fromarray(arr).resize(
            (int(w*self.scale), int(h*self.scale)),
        )
        # 사진을 확대합니다.
        # 이때 부족한 픽셀을 채우기 위해 가장 가까운 픽셀 값을 사용하여 확대 시 픽셀 블록화 효과를 줌
        # Image.NEAREST은 가장 가까운 값을 사용하여 확대 시 픽셀 블록화 효과를 줌 다른 옵션으로는 Image.BILINEAR, Image.BICUBIC 등이 있음
        mosaiced_image = downscaled_image.resize((w, h), Image.NEAREST)
        mosaiced_image.save(self.output_path)

        print(f"Mosaic saved to {self.output_path}")


if __name__ == "__main__":
    input_file = "image.png"
    output_file = "mosaic_output.png"
    image_mosaic = ImageMosaic(input_file, output_file, scale=0.05)
    image_mosaic.apply_mosaic()

# 요약
# 이미지를 축소를 하면은 픽셀 수 가 줄어듭니다.
# 이미지를 확대를 하면은 픽셀 수 가 늘어납니다.
# 이때 축소 된 이미지를 확대를 할 때 축소된 이미지의 픽셀이 부족하기 때문에 확대 시 픽셀을 채우기 위해 가장 가까운 픽셀 값을 사용하여 확대 시 픽셀 블록화 효과를 줌
# 그 블록화로 인하여 원본 이미지의 픽셀 값이 손실되어 원본 이미지와 다르게 보입니다.
# 이러한 효과를 모자이크 효과라고 합니다.
