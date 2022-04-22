# How to contribute to this repository and how to replicate it
<sup>back to the [README](https://github.com/worldbank/LearningPoverty/blob/master/README.md) :leftwards_arrow_with_hook:</sup>

### Table of Contents
1. [Replicating this Repository](#replicating-this-repository)
1. [Contributing to this Repository](#contributing-to-this-repository)
  2.1. [Bug reports and feature requests](#bug-reports-and-feature-requests)   
  2.2. [Contribution conventions](#contribution-conventions)  
1. [Workflow in this Repository](#workflow-in-this-repository)   
  3.1. [Quick summary of workflow](#quick-summary-of-workflow)  
  3.2. [Details of main branches](#details-of-main-branches)  

## Replicating this Repository

This repository contains all material necessary to replicate the results of our paper. To replicate it, you will need R and Stata to execute the code. All code necessary to replicate our results, as well as all raw data is contained in this repository. Both the code and the raw data (csv and md files) are automatically rendered by GitHub, so you can immediately inspect the code and the data by navigating the folders.

See the [Repository Structure Note](https://github.com/worldbank/LearningPoverty/blob/master/00_documentation/002_repo_structure/Repo_Structure.md) to understand the sequencing of the tasks, visualizing the data flowcharts in this project and for an overview of the variables in each dataset.

## Contributing to this Repository

If you are familiar with how GitHub works, please feel free to make a fork and submit a pull request for any additions you want to make, but please read the **contribution conventions** section below first. If you are new to GitHub, start by reading the **bug reports and feature requests** section below.

### Bug reports and feature requests
An easy but still very efficient way to provide any feedback on this repository that does not require any GitHub knowledge is to create an *issue*. You can read *issues* submitted by other users or create a new *issue* [here](https://github.com/worldbank/LearningPoverty/issues). While the word *issue* has a negative connotation outside GitHub, it can be used for any kind of feedback. If you have an idea for a new analysis or would like to report an error, creating an *issue* is a great tool for communicating that to us. Please read already existing *issues* to check whether someone else has made the same suggestion or reported the same error before creating a new *issue*.

### Contribution conventions

In addition to using common GitHub practices and to the workflow practices of this repo, please follow these conventions to make it possible to keep an overview of the progress made to the code in this repository.

If your commit is specifically addressing an error, then always name your commit starting with `[BUG FIX]`. If you have opened an issue, you may want to reference the issue in the commit message, for example `fix issue #122`. If you want feedback on your solution to the issue or help with testing it, then ask for that before you merge the fix to the `develop` branch. If your branch contains many changes back and forth, then we suggest that you do a squashed merge to the `develop` branch. Squashed merge means that all commits in the fix issue branch are combined into a single commit in the `develop` branch where only the final changes are reflected. All commits in the branch are still saved individually in the history of that branch.

## Workflow in this Repository

### Quick summary of workflow

* No edits should be done directly to the `master` branch. Instead, code edits should be made to the `develop` branch, and documentation edits should be made to the `documentation` branch.
* If you are making large edits to the `documentation` branch, then create a branch of the `documentation` branch and then open up a pull request.
* If you are making code edits you should always start by making a branch from the `develop` branch.
* Create many branches and merge them often. That is the best way to make sure there are no conflicts when merging, and that makes sure that the team has the most up to date version of the code.
* While the project is under development, all committed and pushed branches will be merged to the `develop` branch by the end of the day, unless made explicitly in the name of the branch in the main REPO, by adding `_dnm_<branchname>` (dnm = do_not_merge) or `_do_not_merge_<branchname>`

### Details of main branches

* `master` branch
    * Only users _jpazvd_ and _dianagold_ have push access to this branch (maintainers).
    * This branch is only merged to when the project reaches some kind of milestone. It does not have to be a big milestone like a publication, could also be the end of a deadline before a senior meeting etc.
    * No one works directly in this branch. We first update the `develop` branch and make sure that everything runs there without error, then we merge the `develop` branch to the `master` branch. The `master` branch may also receive merges from the `documentation` branch, but this should only be used for changes in the documentation.
* `develop` branch
    * Only users _jpazvd_ and _dianagold_ have push access to this branch (maintainers).
    * Everyone starting a new task should branch from this branch. You do not need push access to create a branch, so anyone can make a branch from `develop`.
    * Make one branch for each task and keep those tasks small. It is fine to submit your branch multiple times per day. That ensures that merge conflicts are rare. Make sure to give your branch an explanatory name. Micro-commiting is a good practice, so it's easy to revert back to a commit if the need arises.
    * When you want to merge your task, simply open up a new pull request and one of the maintainers will merge the branch for you. Assigning one of the maintainers as a reviewer of your pull request will ensure a speedy review, for they will be notified.
* `documentation` branch
    * This branch should only be used to update the documentation files.
    * It may be merged directly to `master`, bypassing a merge with `develop`, which may be useful to preserve links and do small revisions of the documentation.
* `QA` branch
    * This branch is used to create a version of the `develop` branch that is replicable. Any small edits to be made for the code to be replicable should happen in this branch.
    * When the `QA` branch is replicable, then it should be rebased on `development` (if needed) to make sure that any additional changes are included. Then it should be tested again that the code is replicable, if it is then merge `QA` to `develop`, and then merge `develop` to `master`
