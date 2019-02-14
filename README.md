# dag-factory

[![Travis CI](https://img.shields.io/travis/ajbosco/dag-factory.svg?style=flat-square)](https://travis-ci.com/suchitpuri/auto-compose)
[![Code Style](https://img.shields.io/badge/code%20style-black-000000.svg?style=flat-square)](https://github.com/ambv/black)

*auto-compose* is a utility for dynamically generating Google cloud managed [Apache Airflow](https://cloud.google.com/composer/) DAGs from YAML configuration files. It is a fork of [*dag-factory*](https://github.com/ajbosco/dag-factory) and uses its logic to parse YAML files and convert them to airflow DAG's.

- [Installation](#installation)
- [Usage](#usage)
- [Benefits](#benefits)
- [Contributing](#contributing)
  
## Installation

To install *dag-factory* run `pip install dag-factory`. It requires docker, Python 3.6.0+ and Apache Airflow 1.9+.

[![Open in Cloud Shell](http://gstatic.com/cloudssh/images/open-btn.svg)](https://console.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https%3A%2F%2Fgithub.com%2Fsuchitpuri%2Fauto-compose&cloudshell_print=cloudshell-run.txt&cloudshell_open_in_editor=bootstrap.sh)


## Usage

After installing *dag-factory* in your Airflow environment, there are two steps to creating DAGs. First, we need to create a YAML configuration file. For example:

```
example_dag1:
  default_args:
    owner: 'example_owner'
    start_date: 2018-01-01
  schedule_interval: '0 3 * * *'
  description: 'this is an example dag!'
  tasks:
    task_1:
      operator: airflow.operators.bash_operator.BashOperator
      bash_command: 'echo 1'
    task_2:
      operator: airflow.operators.bash_operator.BashOperator
      bash_command: 'echo 2'
      dependencies: [task_1]
    task_3:
      operator: airflow.operators.bash_operator.BashOperator
      bash_command: 'echo 3'
      dependencies: [task_1]
```

Then in the DAGs folder in your Airflow environment you need to create a python file like this:

```
from airflow import DAG
import dagfactory

dag_factory = dagfactory.DagFactory("/path/to/dags/config_file.yml")

dag_factory.generate_dags(globals())
```

And this DAG will be generated and ready to run in Airflow!

![screenshot](/img/example_dag.png)

## Benefits

* Construct DAGs without knowing Python
* Construct DAGs without learning Airflow primitives
* Avoid duplicative code
* Everyone loves YAML! ;)

## Contributing

Contributions are welcome! Just submit a Pull Request or Github Issue.


