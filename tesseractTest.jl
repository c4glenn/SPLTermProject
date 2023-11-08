using OCReract
using Images

# For this file to run you need to have tesseract installed https://tesseract-ocr.github.io/tessdoc/Installation.html

img_path = "lightbox.jpg"
img = load(img_path)

res = run_tesseract(img)

println(strip(res))
