# Qias - unit conversion in Matlab
Unit Conversion in Matlab with the ability to quickly add new units. The code is based on graph theory to determine the relationships between units. Because of this, only one conversion factor need to be provided for each new unit. There is no need to define all units in one standard unit. The code can relate to other units automatically.

## Why a library for a simple thing such as units?
Units can be annoying to handle in code. I had a couple of objectives for writing this code (aside from it being a cool very practical application of graph theory):
- Reusability: a code that I can use in multiple projects.
- Extendibility: new units and physical properties can be added easily without modifying the code at all.
- Simplicity: calling functions should be intuitive for Matlab users.

## Usage
Here is an example of usage. Check the example file for more information.

```
qs = Qias();
[valueUnitTo, multiplier, property] = qs.convert(2, 'm', 'in')
```

## How to add new units
The “Graph” folder contain CSV files with some already available units. You can create new CSV files for new physical properties. In each CSV file, new units can be added and they only need to be defined based on one unit. If you created a nice CSV file for new physical property or extended one that is already there. Please give me a shout and I will add it.

## Behind the scenes
Graph theory is used to determine the relationship between any two units. For example, meters and feet can be defined in CSV file. Next, feet and yard relationship is defined. The algorithm uses the shortest path to automatically figure out the relationship between meter and yard. Here is an example of the input CSV file (left) and the relationships that can be built from it automatically (right).

<div align="center">
    <img width=1000 src="https://github.com/MosGeo/Qias/blob/master/Figures/GraphExample.png" alt="Graph" title="Graph example"</img>
</div>

## Requirements
The code is tested on Matlab 2018a but, as far as I know, it should work on older versions and it should not need any special toolboxes besides the basic core Matlab.

## Reference
I would love to hear from you if you are using this code in your work. My email is Mustafa.Geoscientist@outlook.com. You can reference the library using:

```
@Manual{Qias,
  title  = {Qias, unit conversion in matlab},
  author = {Mustafa Al Ibrahim},
  year   = {2018},
  note   = {matlab~package version~1.0},
  url    = {https://github.com/MosGeo/Qias},
}
```
