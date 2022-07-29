# Associated Domains Example
Example project to showcase Universal Links and Web Credentials working with a client side app.

## AASA File Example
`
{
    "applinks": {
        "details": [
            {
                "appIDs": [
                    "UL3RBMBKF2.com.lowe.associateddomains"
                ],
                "components": [
                    {
                        "#": "no_universal_links",
                        "exclude": true,
                        "comment": "Matches any URL whose fragment equals no_universal_links and instructs the system not to open it as a universal link"
                    },
                    {
                        "/": "/services/applinks/*",
                        "comment": "Matches any URL whose path starts with /services/applinks"
                    }
                ]
            }
        ]
    },
    "webcredentials": {
        "apps": [
            "UL3RBMBKF2.com.lowe.associateddomains"
        ]
    }
}
`

TODO: Add Sample Video

## Topics
#AssociatedDomains #UniversalLinks #WebCredentials
