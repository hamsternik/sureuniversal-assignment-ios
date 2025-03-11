OS_VERSION ?=18.3.1
IPHONE ?=iPhone 16 Pro
#-destination "platform=iOS Simulator,OS=18.3.1,name=iPhone 16 Pro"
DESTINATION ?="platform=iOS Simulator,OS=$(OS_VERSION),name=$(IPHONE)"
SCHEME ?=SureUniversalAssignment

PIPELINE_ERROR = set -o pipefail &&
XCODEBUILD := xcodebuild
BEAUTIFY := xcbeautify

XCODEBUILD_PIPELINED := $(PIPELINE_ERROR) $(XCODEBUILD)
BUILD_FLAGS := -project SureUniversalAssignment.xcodeproj -scheme $(SCHEME) -destination $(DESTINATION) -skipPackagePluginValidation
TEST_FLAGS := $(BUILD_FLAGS) -configuration Debug #-testPlan UnitTestsAll
EXTENDED_BUILD_FLAGS := CFLAGS="-ferror-limit=0"

help: 
	@cat Makefile

open: 
	@xed .

validate-gh-actions:
	@act push -P macos-latest=-self-hosted

xcodebuild:
	$(PIPELINE_ERROR) $(XCODEBUILD) $(CMD_ARG) $(BUILD_FLAGS) $(EXTENDED_BUILD_FLAGS) | $(BEAUTIFY)

# Lists the targets and configurations in a project, or the schemes in a workspace. Does not initiate a build.
xcodebuild-configs-json:
	xcodebuild -list -json

xcodebuild-version:
	xcodebuild -version

xcodebuild-swift-version:
	xcodebuild -showBuildSettings | grep SWIFT_VERSION

clean: xcodebuild-version xcodebuild-swift-version
	set -o pipefail && xcodebuild clean -scheme SureUniversalAssignment

build: xcodebuild-version xcodebuild-swift-version
	set -o pipefail && xcodebuild build -scheme SureUniversalAssignment | xcbeautify

test: xcodebuild-version xcodebuild-swift-version
	set -o pipefail && xcodebuild test -scheme UnitTests -destination $(DESTINATION) | xcbeautify

# test-ci: xcodebuild-version swift-version
# 	$(PIPELINE_ERROR) $(XCODEBUILD) test $(TEST_FLAGS) | $(BEAUTIFY) --renderer github-actions
