using OCReract
using Images

img_path = "lightbox.jpg"
img = load(img_path)

res = run_tesseract(img)

println(strip(res))