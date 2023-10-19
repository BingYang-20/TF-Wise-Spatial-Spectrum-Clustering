# TF-Wise-Spatial-Spectrum-Clustering
A MATLAB implementation of “**<a href="https://ieeexplore.ieee.org/document/8712393" target="_blank">Multiple Sound Source Counting and Localization Based on TF-Wise Spatial Spectrum Clustering</a>**”, IEEE/ACM Transactions on Audio, Speech, and Language Processing (TASLP), 2019.

<div align=center>
<img src=https://user-images.githubusercontent.com/74909427/218236039-1878ab95-edae-46b3-90b1-c1d1c79dbb0b.png width=80% />
</div>

## Main Description
+ **MSSL.py** is the main implementation of the proposed method
    - **SinSouTF.py** provides the binary TF weight for single source dominated TF bins and the ranked eigenvectors of spatial correlation matrix
    - **TFSpatSpect.py** calculates the TF-wise spatilal spectrum (see method description in Section III)
    - **SouCouLoc** joint counts and localizes multiple sound sources (see method description in Section IV)
    - **sv.mat** stores the steering vector for the considered 8-channel uniform circular microphone array
+ **example.py** gives an example for multiple sound source localization on the data x.mat
+ **x.mat** stores one instance of microphone signals (1s, 16000samples, 8 channels)

## Quick Start
+ run example.py
+ If you want to change test data, you can change the loaded mat data (currently x.mat) in example.py
+ If you want to change the topolopy of microphone array (number of mircophones or geometry), you need to change the steering vector (currently sv.mat) in MSSL.py according to array topology

## Citation
If you find our work useful in your research, please consider citing:
```
@InProceedings{yang2019TFSSC,
    Author = "Bing Yang and Hong Liu and Cheng Pang and Xiaofei Li",
    Title = "Multiple Sound Source Counting and Localization Based on {TF}-Wise Spatial Spectrum Clustering",
    Journal = "{IEEE/ACM} Transactions on Audio, Speech, and Language Processing (TASLP)",
    Volume = "27",	
    Number = "8",
    Pages = "1241-1255",
    Year = "2019"}
```

## Licence
MIT
