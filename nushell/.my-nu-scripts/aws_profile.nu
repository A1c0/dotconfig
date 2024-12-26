def aws_profil [] {open $"($env.HOME)/.aws/config" | lines | parse "[profile {profil}]" | get profil };

export def "current" [] {
    aws sts get-caller-identity | str replace --all --regex '\n\s*' '' | from json
}

export def --env "switch" [profile: string@aws_profil] {
    if $profile == "default" {
        hide-env AWS_PROFILE
    } else {
        $env.AWS_PROFILE = $profile;
    }
}

export def "remove_role" [role_name : string] {
    print $"removing role ($role_name)..."

    let rolePolicies = aws iam list-role-policies --role-name $role_name | from json | get PolicyNames;
    print "need to remove these policies:";
    print $rolePolicies;

    let attachedPolicies = aws iam list-attached-role-policies --role-name $role_name | from json | get AttachedPolicies;
    print "need to detach these policies:";
    print $attachedPolicies;

    $attachedPolicies | each {aws iam detach-role-policy --role-name $role_name --policy-arn $in.PolicyArn};
    $rolePolicies | each {aws iam delete-role-policy --role-name $role_name --policy-name $in};
    aws iam delete-role --role-name $role_name;
    print $"role ($role_name) is deleted"
}
