Evolution is a Ruby implementation of a hill-climbing algorithm that uses RMagick to generate a collection of polygons which resemble a baseline image. It does this by starting with a blank canvas and a single polygon with random points, color and opacity. It then takes the original polygon and randomly mutates it (by moving a point, adding a point or changing the color / opacity), and with the possibility of adding a new random polygon as well. Between the original image and the mutated version, whichever one more closely resembles the baseline is kept and used to seed the next mutation.

```
     generation: 1               generation: 2              generation: 3

 +-------------------+       +-------------------+      +-------------------+
 | image 001         |       | image 002         |      | image 002         |
 | similarity: 3.0 % |   +-->| similarity: 3.2 % |----->| similarity: 3.2 % |    +--> ...
 +-------------------+   |   +-------------------+      +-------------------+    |
           |             |             |                          |              |
           |             |             |                          |              |
    random mutation      |      random mutation            random mutation       |
           |             |             |                          |              |
           v             |             v                          v              |
 +-------------------+   |   +-------------------+      +-------------------+    |
 | image 002         |---+   | image 003         |      | image 004         | ---+
 | similarity: 3.2%  |       | similarity: 3.1%  |      | similarity: 3.3%  |
 +-------------------+       +-------------------+      +-------------------+
 ```

### Usage

```
git clone https://github.com/joeyschoblaska/evolution.git
cd evolution
bundle
rake run
```

Rendered images and svg files will be placed in the `images/renders` directory.

### Options

The following environment variables can be set when using the `rake run` command:

**baseline_image**: The path to the image you want to render. The larger the image, the more time it will take RMagick to compare each set of candidates, and the longer it will take to converge. Default: './images/baseline.jpg'

**canvas_background**: The color of the canvas, behind the rendered polygons. Default: 'white'

**add_polygon_mutation_rate**: The rate at which new polygons will occur during mutations. There is a 1/x chance of this mutation occuring, so setting it to 1 will result in a new polygon in each mutation, while setting it to 100 will result in a 1% of a new polygon being added in each mutation. Default: 300

**rgba_mutation_rate**: The rate at which polygons will have their RGBA values changed during mutations. There is a 1/x chance of this mutation occuring. Default: 300

**point_mutation_rate**: The rate at which points will have their coordinates changed during mutations. There is a 1/x chance of this mutation occuring. Default: 300

**add_point_mutation_rate**: The rate at which new points will be added to polygons during mutations. There is a 1/x chance of this mutation occuring. Default: 500

**fitness_target**: Each candidate receives a "fitness" score according to how similar it is to the target baseline image, with a score of 0 indicating a perfect match. The fitness_target is the value which, when reached, will cause the program to end. Default: 500

**write_frequency**: Every x successful mutations, render the image to the `images/renders` directory and save the svg string. Default: 100
