typedef GlobalWidgetTypeToRefer = GlobalWidget;

class GlobalWidgetDescription {
  final String usage;
  final String? figmaUrl;
  final GlobalWidgetTypeToRefer widgetType;

  /// A unique identifier for this widget (e.g., to track usage or debug).
  final String uniqueKey;

  const GlobalWidgetDescription({
    required this.usage,
    required this.uniqueKey,
    required this.widgetType,
    this.figmaUrl,
  });
}

enum GlobalWidget {
  saveJobIcon,
  backArrowIcon,
  primaryElavtedButton,
  primaryOutlinedButton,
  copyClipBoardIcon,
  shadowOutlinedButton,
  messageIcon,
  notificationIcon,
  searchIcon,
  shareAndRefferalIcon,
  jobDetailsBenefits,
  jobDetailsCertification,
  jobDetailsLicense,
  jobDetailsCard,
  jobDetailsHeader,
  jobDetailsSkill,
  rolesAndResponsibility,
  jobDetailsView,
  loadingWidget,
  paginationWidget,
  phoneNoTextFromField,
  locationTextFromField,
  titleTextFormField,
  checkBoxWidget,
  chooseEnterprise,
  circularProgressIndicatorWidget,
  customAppBar,
  customAvtar,
  customDrawer,
  customDropdown,
  customMultiDropdown,
  customButton,
  deleteButton,
  dilaogs,
  dot,
  expandable,
  infoChip,
  interactiveIcon,
  multiselectDropdown,
  noJobFoundWidget,
  orWigdet,
  parentBgWidget,
  radioButton,
  radio,
  buttonRadio,
  selectedChip,
  expansionTile,
  selectedCircle,
  snackBarMessage,
  splashScreen,
  statusBanner,
  switchWidget,
  tagChip,
  uploadDocs,
  widgetWithTitle,
widgetTitleStar, 
outlinedButtonWithIconLable
  
}
