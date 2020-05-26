# Canny-Edge-Detection

<b>Canny edge detection</b> is an edge detection technique that uses a multi-stage algorithm. This technique is used to in image processing for edge detection with noise suppression.

### The algorithm includes:
1. #### Image Filtering to Smooth Image
2. #### Intensity Gradient Magnitude
3. #### Non Maximum Suppression
4. #### Double Thresholding
5. #### Connecting Strong Edges and Suppressing Weak Edges

## Input Image
<img align="center" width="650" height="250" src="images/cars.jpg">

## Output Image
<img align="center" width="650" height="250" src="images/fixing_broken_edges.png">

## Image Processing in Each Stage

### 1. Image Filtering
<img align="center" width="650" height="250" src="images/smoothing.png">

### 2. Gradient Magnitude
<img align="center" width="650" height="250" src="images/directional_gradients.png">
<img align="center" width="650" height="250" src="images/gradient_magnitude.png">

### 3. Non Maximum Suppresion
<img align="center" width="650" height="250" src="images/nms.png">

### 4. Double Thresholding
<img align="center" width="650" height="250" src="images/double_thresholding.png">

### 5. Connecting Strong Edges and Suppressing Weak Edges
<img align="center" width="650" height="250" src="images/fixing_broken_edges.png">
