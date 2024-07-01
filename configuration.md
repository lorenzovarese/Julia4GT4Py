
### Configuration Pinz Daint/Tödi

#### SSH Connection

1. Generate the ssh key from: [SSH Key Gen](https://sshservice.cscs.ch/)

2. Copy the public and the private key to the ~/.ssh folder

3. Change the permission of the private key file:
```bash
chmod 600 ~/.ssh/cscs-key
```

4. Add the key to the SSH agent:
```bash
ssh-add -t 1d ~/.ssh/cscs-key
```

#### Access to the cluster

1. Run the command to connecting to the login node ("Ela"):
```bash
ssh -A cscs_username@ela.cscs.ch
```

2. If you want it is possible to directly connect to the node:
```bash
ssh -A cscs_username@daint<NODE_NUMBER>.cscs.ch
```

3. The computing note could be called with and `srun` command that triggers the execution of a shell on that node. 
The following command specify the allocation of an interactive gpu shell:
```bash
srun -A csstaff -C gpu --time=2:00:00 --pty bash
```

And this one, for a multicore partition:
```bash
srun -A csstaff -C mc --time=2:00:00 --ntasks=1 --cpus-per-task=36 --pty bash
```

Note: you can also use zsh.

### Standard operation in the cluster

1. It is important to use the $HOME folder rarely. It is recomended to use the $SCRATCH folder instead.
```bash
cd $SCRATCH
```

2. It is suggested to use the Spack package manager, see the part of the guide to install it and then you can use this following commands when you need them:
```bash
spack env list # List all the enviroments that are present

spack env activate <ENV_NAME> # Activate a specific enviroment

spack env status # Check which env. is active

spack env deactivate # Deactivate current enviroment
```

### Use zsh instead of bash (optional)

If you prefer to use zsh instead of bash here an easy guide to setup it.

1. Activate zsh:

```bash
zsh
```

### Install Oh-My-Zsh

1. After connecting via ssh, run the command to install oh-my-zsh (check the updated one on the [repo](https://github.com/ohmyzsh/ohmyzsh)):
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

2. Run the zsh command and select "no" to the option of the default terminal:
```bash
Time to change your default shell to zsh:
Do you want to change your default shell to zsh? [Y/n]

n
```

3. Go to the home folder:
```bash
cd $HOME
```

4. Create/Update the `.bash_profile` file adding the following commands:
```bash 
tty > /dev/null
if [[ $? == 0 ]]; then
  fpath=(
        $MODULESHOME/init/sh_funcs/no_redirect
        /usr/share/zsh/site-functions/
        /usr/share/zsh/functions/*
        /usr/share/zsh/functions/*/*
  )
  FPATH=$( IFS=$':'; echo "${fpath[*]}" ) zsh
fi
```
Note: this is useful to avoid the automatic run of scripts at at each run of the terminal, and at the same time it guarantees the `zsh` on startup.

5. Customize zsh (optional). Open the confiuration file:
```bash
vi ~/.zshrc
```

Change the theme:
```bash
...
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

ZSH_THEME="<CHANGE THIS>" # I personally use `agnoster`
...
```

6. List of suggested plugins:
 - [Syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
 - [Auto suggestions](https://github.com/zsh-users/zsh-autosuggestions)
 - [History substring search](https://github.com/zsh-users/zsh-history-substring-search)

7. Reload zsh to apply the changes.
```bash
source ~/.zshrc
```

### Install Spack

1. Move to the `$SCRATCH` folder;
```bash
cd $SCRATCH
```

2. Load gcc:
```bash
module load gcc
```

3. Clone the [Spack repo](https://github.com/spack/spack)
```bash
git clone https://github.com/spack/spack.git
```

4. (optional) Add/Create a configuration file for the enviroment. Like in this `config.yaml` example.

```yaml
spack:
    specs:
    - python@3.10
    - py-pip
    - boost
    - cmake
    #- py-cupy cuda_arch=60 ^cuda+allow-unsupported-compilers ^nccl+cuda cuda_arch=60
    view: true
    concretizer:
      unify: true
```

5. Create a new Spack environment (the configuration is optional):
```bash
spack env create <myenv_name> config.yaml
```

4. Activate the new enviroment:
```bash 
spack env activate <myenv_name> 
```

5. If you have not passed a configuration at the creation stage you can add the dependency that you need.

    - Add the dependency manually `spack add <dep_name>` or from a file `spack add <config.yaml>`
    - Install the dependencies: `spack install`

### Spack Troubleshooting

#### Compilation Error
If you need to change the current gcc compiler to fix some compilation problem you can follow this procedure.

1. `spack location --install-dir gcc@11` (Important: this needs to be executed outside your environment)
2. Activate your env
3. `spack compiler rm -a gcc`
4. `spack compiler find <INSTALL DIR FROM ABOVE>`

Then you can move to your environment and try again to compile. If you obtain an error, it is possible that other packages have been concretized with the preavious compiler version, to enforce the concretization with the new compiler you can use `spack concretize --force`.
To check the current/available compiler you can use the command: `spack compiler list`

### Miscelaneous

#### Example SLURM commands for managing jobs

1. Run a job (simple example to get a shell)
```bash
srun -A csstaff -C gpu --time=2:00:00 --pty zsh
```

2. Check the queue of job of the current user
```bash
squeue -u $USER
```

3. Kill a job
```bash
scancel <jobid>
```

4. Run a batch file
```bash
sbatch <script>.sh
```

Script example:
```sh
#!/bin/bash -l
#SBATCH --job-name=multicore_job
#SBATCH --account=csstaff
#SBATCH --partition=normal
#SBATCH --time=2:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=36
#SBATCH --output=multicore_job.out
#SBATCH --error=multicore_job.err
#SBATCH -C mc

# Load necessary modules
module load PrgEnv-cray
module load cray-mpich

# Run your application
srun ./multicore_app
```

Note: `srun` vs `sbatch`
- `srun` is used to submit a job for execution in real time
- `sbatch` is used to submit a job script for later execution

#### Handling module

To list all the available modules, use:
```bash
module avail
```
(Note: `module list` shows currently loaded modules, whereas `module avail` shows all modules that can be loaded.)

Load specific modules:
```bash
module load <module_name>
```

For all modules that are not already available, Spack is a good option. Here an example:
```bash
# Spack should be initialized
source /<path/to/spack/share/spack>/setup-env.sh

spack env activate <myenv>

spack add julia

spack install

spack load julia
```
