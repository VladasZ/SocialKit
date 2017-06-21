# SocialKit

Add to plist:

VK:

<key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
                <string>Editor</string>
            <key>CFBundleURLSchemes</key>
                <array>
                    <string>vk{APP_ID}</string>
                </array>
        </dict>
    </array>


<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>vkauthorize</string>
        <string>vk{APP_ID}</string>
    </array>

Facebook:

<key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
                <string>Editor</string>
            <key>CFBundleURLSchemes</key>
                <array>
                    <string>fb{APP_ID}</string>
                </array>
        </dict>
    </array>


<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>fbapi</string>
        <string>fb-messenger-api</string>
        <string>fbauth2</string>
        <string>fbshareextension</string>
    </array>



