# A Data-Driven Approach to Morphogenesis under Structural Instability

## Overview

Morphological development into evolutionary patterns under structural instability is a pervasive phenomenon in living systems, which often holds crucial implications for engineering structures.
In light of this, we propose a data-driven approach to comprehend and predict the spatiotemporal complexities of such systems.
A machine-learning framework is devised based on physical modeling of morphogenesis triggered by internal or external stimuli.
Digital libraries of structural patterns are constructed using simulation data, which can be employed to identify anomalies, predict development, and assist in risk assessment and prognosis.
The ability to pinpoint key bifurcation characteristics and predict history-dependent development is demonstrated through examples of brain growth and aerospace structural design, providing guidelines for disease diagnosis/prognosis and instability-tolerant design.

## Installation

```
git clone https://github.com/zhaoyj21/instability_tolerance/
cd instability_tolerance
pip install -e .
```

## Building digital libraries

The codes for  morphogenesiss of brain were coded in `python 2.7`, but they are compatible to `python 3.7`
Python packages and versions:
```
enum34==1.1.6
funcsigs==1.0.2
llvmlite==0.24.0
nibabel==2.5.1
numba==0.39.0
numpy==1.17.2
numpy-stl==2.10.1
python-utils==2.3.0
scikit-learn==0.21.3
scipy==1.3.1
singledispatch==3.4.0.3
six==1.12.0
Vapory==0.1.1
mpmath==1.0.0
os
trimesh
slam
```

You can use the file `requirements.txt` to install all the python packages.
```
cd ./01_data_generation/BrainGrowth/
pip install -r requirements.txt
```

Run the code to generate brain morphologies:
```
python simulation.py -i './data/brain.mesh' -o './res/brain' -hc 'whole' -t 0.042 -g 1.829 -gm 'global'
```

## Unsupervised clustering

Run the the file `mor_GI_Curvature.ipynb` to extracted descriptors of morphologies.

```
cd ./02_cluster
runipy mor_GI_Curvature.ipynb
```

Run the the file `mor_cluster.ipynb` to cluster the morphologies based on descriptors.
```
runipy mor_cluster.ipynb
```

## Morphological idenificaion

Run the code to divide the datasets  for training, validation and testing and label the morphological data utilizing unsupervised clustering.

```
cd ./03_classification
runipy cpflie_to_mor_data.ipynb
runipy mk_raw_dataset.ipynb
runipy dataset_label.ipynb
runipy dataset_label_divi.ipynb
```

Run the code for training and testing and evluate the results.
```
runipy train_mor_classification.ipynb
runipy test_mor_classification.ipynb
runipy metrics_mor_classification.ipynb
```

## Dimension reduction

We adopt PointNet autoencoder to learn the latent representations of morphologies.

Run the code for prepare dataset:

```
cd ./04_reduce_dimension
runipy obtain_sequence_and_ae_dataset.ipynb
```
Run the code for training:

```
cd ./04_reduce_dimension/PointNet_AE/notebooks
runipy train_single_class_ae_brain.ipynb
```

Run the code for generating reduced squence for downstream tasks of pattern evolution.

```
cd ./04_reduce_dimension
runipy enlong_sequence.ipynb
runipy lstm_sequence.ipynb
```

## Patterns development

We adopt LSTM autoencoder to learn the historical dependency of morphological development.

Run the code for training and validation.

```
cd ./05_development
runipy lstm_brain.ipynb
```

Run the code for quantitative evaluation of prediction results using Chamfer distance.
```
cd  ./04_reduce_dimension/PointNet_AE/notebooks
runipy metrics_chamfer.ipynb
```

## Bifurcation characterization

We adopt DEVs analysis to identify the bifurcation behavior of morphological development.

Run the code for the calculation of DEVs:

```
cd  ./06_characterization
Rscript gi_series_analyse.R
Rscript lf_series_analyse.R
```

## References

- Wang, X., Lefèvre, J., Bohi, A., Harrach, M. A., Dinomais, M., & Rousseau, F. (2021). [The influence of biophysical parameters in a biomechanical model of cortical folding patterns](https://www.nature.com/articles/s41598-021-87124-y), Scientific Reports, 11(1), 7686.
- Achlioptas, P., Diamanti, O., Mitliagkas, I., & Guibas, L. (2018). [Learning representations and generative models for 3d point clouds](https://proceedings.mlr.press/v80/achlioptas18a.html), In International conference on machine learning (pp. 40-49). PMLR.
- Grziwotz, F., Chang, C. W., Dakos, V., van Nes, E. H., Schwarzländer, M., Kamps, O., ... & Hsieh, C. H. (2023). [Anticipating the occurrence and type of critical transitions](https://www.science.org/doi/full/10.1126/sciadv.abq4558), Science Advances, 9(1), eabq4558.