import numpy as np
from matplotlib import pyplot as plt
import cv2

img = cv2.imread("lenna.png")
size = (img.shape[0:2])
#size = (400,400)
print(size)

# cut the image down
img = img[0:size[0],0:size[1]]

plt.figure(figsize = (15,15))
plt.subplot(121), plt.imshow(img)
plt.title('BGR'), plt.xticks([]), plt.yticks([])
img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
plt.subplot(122), plt.imshow(img)
plt.title('RGB'), plt.xticks([]), plt.yticks([])
plt.show()

f = open('data_rgb.in', 'w')
f.write(hex(size[0])[2:]+"\n")
f.write(hex(size[1])[2:]+"\n")

R = img[:,:,2]
G = img[:,:,1]
B = img[:,:,0]
for x in range(0,size[0]):
    for y in range(0,size[1]): 
        z = str('{0:0{1}X}'.format(R[x,y],2)+'{0:0{1}X}'.format(G[x,y],2)+'{0:0{1}X}'.format(B[x,y],2))
        f.write(z+"\n")
f.close()

img_golden = cv2.imread("lenna.png")
img_golden = cv2.cvtColor(img_golden, cv2.COLOR_BGR2GRAY)

# cut the image down
img_golden = img_golden[0:size[0],0:size[1]]

f = open('data.gold', 'w')

for x in range(0,size[0]):
    for y in range(0,size[1]): 
        z = '{0:0{1}X}'.format(img_golden[x,y],2)
        #print(z)
        f.write(z+"\n")
f.close()

with open('data.out') as f:
    f.readline()
    f.readline()
    f.readline()
    read_data = f.read()

#print(len(read_data))

img_rtl = np.arange(len(read_data)/7)
    
for x in range(int(len(read_data)/7)):
   img_rtl[x] = int(read_data[x*7+4:x*7+6], 16)

img_rtl = img_rtl.reshape(size)

#def show_image(im):
#  plt.figure(figsize = (10,10))
#  plt.imshow(im,cmap='gray',vmin=0,vmax=255)
#  plt.show()

#show_image(img_rtl)
img_delta = np.abs(img_rtl - img_golden)

plt.figure(figsize = (15,15))
plt.subplot(2,2,1), plt.imshow(img_golden,cmap='gray',vmin=0,vmax=255)
plt.title('Golden'), plt.xticks([]), plt.yticks([])
plt.subplot(2,2,2), plt.imshow(img_rtl>70,cmap='gray',vmin=0,vmax=1)
plt.title('HW Result'), plt.xticks([]), plt.yticks([])
#plt.subplot(2,2,(3,4)), plt.imshow(np.abs(img_rtl - img_golden),cmap='gray',vmin=0,vmax=255)
#plt.title('Delta (max =' + str(np.max(img_delta)) + ')'), plt.xticks([]), plt.yticks([])
plt.show()
