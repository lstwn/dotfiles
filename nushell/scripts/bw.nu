export def "bw enable" [] {
    let value = ($env | get --ignore-errors BW_SESSION)
    let-env BW_SESSION = if ($value == null || ($value | str trim) == "") {
        (^bw unlock --raw)
    } else {
        $env.BW_SESSION
    }
}

export def "bw copy passwordtotp" [...ids: string] {
    let id = ($ids | reduce { |item, acc| $acc + " " + $item })
    bw enable
    let password = (^bw get password $id)
    let totp = (^bw get totp $id)
    $password + $totp | pbcopy
}

export def "bw copy" [item: string, ...ids: string] {
    let id = ($ids | reduce { |item, acc| $acc + " " + $item })
    ^bw get $item $id | pbcopy
}
