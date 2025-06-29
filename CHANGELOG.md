## 0.0.5 (28-06-2025)

- Added custom item builder (itemBuilder property) for complete control over item rendering
- Added custom select all builder for complete control on select all widget
- Added disabled items support (enabled property in DropDownMenuItemData)
- Improved selection logic to properly handle disabled items

## 0.0.4 (22-06-2025)

### New Features

- Added `autoCloseOnItemTap` property to control dropdown close behavior after item selection
- Added separate `dropdownIcon` & `dropdownOpenIcon` properties for custom toggle icons
- Improved selection handling to maintain state during search operations (fixes disappearing selections issue)

### Bug Fixes

- Fixed issue where selected items would disappear after searching and selecting new items
- Fixed checkbox state inconsistency between filtered and unfiltered views

## 0.0.3 (17-06-2025)

- Added search functionality (`enableSearch` parameter)
- Added loading state support (`showLoading` + `loadingBuilder`)
- Added empty state support (`isEmptyData` + `emptyBuilder`)

## 0.0.2 (14-06-2025)

- Add Topics and resolve some issues

## 0.0.1 (14-06-2025)

- Initial Release
