# here we will define our variables to be used in main.tf
variable "repo_name" {
    default = {
        "one" = {
            "name" = "staging-repo" # add repository name here
        },
        "two" = {
            "name" = "devlop-repo", # add other repostory name here
        }
        
    }
} 
variable "branch_name"{
    type    =  string
    default = "main" # add branch name here
}
 

variable "org_name"{  
    type    = string
    default = "local-organisation" # add organisation name here
}

variable "token_name"{
    type    = string
    default =  "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" # add token here
}

  
variable "git_user"{
    type    = string
    default = "nidhiairi" # add user name here
}

variable "git_user_role"{
    type    = string
    default = "admin" # add user role here
}

