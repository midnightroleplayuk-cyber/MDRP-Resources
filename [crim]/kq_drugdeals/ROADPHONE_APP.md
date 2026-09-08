# Adding custom app to RoadPhonePro

Follow the official guide from Roadshop's documentation page: https://docs.roadshop.org/roadpad/custom-apps#website-app-configuration

___

In brief, add the following json data into `/public/static/config/config.json` and restart your phone.
```json
{
  "name": "Plug",
  "icon": "nui://kq_drugdeals/nui/dist/assets/plug-icon.png",
  "default": true,
  "category": "apps",
  "custom_app_id": "KQ_PLUG_APP",
  "redirect": "custom_app",
  "url": "https://cfx-nui-kq_drugdeals/nui/dist/nui.html?inphone=1",
  "darkmode": true,
  "allowJobs": [],
  "disallowJobs": [],
  "custom_event": {
    "active": false,
    "closeWhenOpenApp": false
  }
}
```

To also add the police app ("LSPD: Narcotics" sting operations + hotspots), add a second entry the same way:
```json
{
  "name": "LSPD: Narcotics",
  "icon": "nui://kq_drugdeals/nui/dist/assets/lspd-icon.png",
  "default": true,
  "category": "apps",
  "custom_app_id": "KQ_LSPD_APP",
  "redirect": "custom_app",
  "url": "https://cfx-nui-kq_drugdeals/nui/dist/nui.html?inphone=1&app=police",
  "darkmode": true,
  "allowJobs": [],
  "disallowJobs": [],
  "custom_event": {
    "active": false,
    "closeWhenOpenApp": false
  }
}
```
The app denies anyone without a police job by itself, so job lists are optional.

Before contacting KuzQuality please make sure to really read through the RoadPhone documentation.
