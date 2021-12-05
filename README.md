# luckyModel

<p align="left">
<a href=""><img src="https://img.shields.io/github/r-package/v/huangwb8/luckyModel"></a>
<a href="https://github.com/huangwb8/luckyModel/blob/master/license.txt"><img src="https://img.shields.io/badge/license-MIT-green"></a>
<a href=""><img src="https://img.shields.io/badge/platform-windows%20%7C%20linux-lightgrey"></a>
<a href=""><img src="https://img.shields.io/github/commit-activity/m/huangwb8/luckyModel"></a>
<a href=""><img src="https://img.shields.io/github/stars/huangwb8/luckyModel?style=social"></a>
<a href="https://github.com/huangwb8/luckyModel/issues"><img src="https://img.shields.io/github/issues-raw/huangwb8/luckyModel"></a>
</p>

### Model ensemble for third-party lucky series, such [**GSClassifier**](https://github.com/huangwb8/GSClassifier)

## :alien: Authors

Weibin Huang (黄伟斌); <654751191@qq.com>

1.  Guangdong Provincial Key Laboratory of Digestive Cancer Research,
    The Seventh Affiliated Hospital of Sun Yat-sen University, No. 628
    Zhenyuan Road, Shenzhen, 518107, Guangdong, People’s Republic of
    China. Digestive Diseases Center

2.  Department of Gastrointestinal Surgery, the First Affiliated
    Hospital of Sun Yat-sen University, 58 Zhongshan 2nd Road, Guangzhou
    510080, Guangdong, People’s Republic of China.

## :+1: Installaton

    # Install "devtools" package
    if (!requireNamespace("devtools", quietly = TRUE))
        install.packages("devtools")
        
    # Install luckyModel
    if (!requireNamespace("luckyModel", quietly = TRUE))
        devtools::install_github("huangwb8/luckyModel")

## :seedling: Common usage

Load the pacakge

    library(luckyModel)

Which projects were supported in current `luckyModel`?

    list_project()

    ## [1] "GSClassifier"

Explore models in a project, just:

    list_model(project='GSClassifier')

    ## Available models in GSClassifier:

    ##   *Gibbs_PanCancerImmuneSubtype_v20190731
    ##   *HWB_PAD_v20200110

Calling a specific model, just:

    model <- lucky_model(project = 'GSClassifier',
                        developer='HWB',
                        model = 'PAD',
                        version = 'v20200110')
    names(model)

    ## [1] "ens"            "scaller"        "geneAnnotation" "geneSet"

## :bowtie: Contribute your model

-   Fork `luckyModel` and make sure you can do somethings like clone,
    commit, and push.

-   Save your model in the local repository of the `luckyModel` package.

<!-- -->

    save_model(x = <Your model>,
               model.path = <local repository>,
               project = <Your project name>,
               model = <Your model name>,
               developer = <Your name>,
               version = <Your model version>)

-   Push to your branch

-   Merge to `master` after audit
