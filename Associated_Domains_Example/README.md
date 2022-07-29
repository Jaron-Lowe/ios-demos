# Associated Domains Example
Example project to showcase Universal Links and Web Credentials working with a client side app.
Key areas to note are the `Associated_Domains_Example.entitlements` and `SceneDelegate.swift` files.

## AASA File Example
The AASA file should be hosted at the root of your domain or in a `/.well-known` directory. It is important that the AASA file have a MIME type of application/json coming from you server but should **NOT** have a `.json` file extension.

```json
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
```

## Universal Links


https://user-images.githubusercontent.com/10712389/181789333-8de27669-3954-4787-b4cd-646101f9ad79.mp4


## Web Credentials


https://user-images.githubusercontent.com/10712389/181789310-6c19d4f0-b016-4d15-9744-9ce272150720.mp4



## Topics
#AssociatedDomains #UniversalLinks #WebCredentials
