TITLE_CHAR_MAX = 140
DETAILS_CHAR_MAX = 255
DEFAULT_THRESHOLD = 5
APP_NAME = "Agora"


MOTION_TITLE_EXPLAIN = "Enter a short title for your motion"
MOTION_DETAILS_EXPLAIN = "Enter more details. The alert e-mail will contain this information."

 FULL_ROOT_URL = YAML.load_file("#{Rails.root}/config/full_root.yml")[Rails.env]