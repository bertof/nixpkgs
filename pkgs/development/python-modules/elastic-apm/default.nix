{
  lib,
  stdenv,
  aiohttp,
  blinker,
  buildPythonPackage,
  certifi,
  ecs-logging,
  fetchFromGitHub,
  httpx,
  jinja2,
  jsonschema,
  logbook,
  mock,
  pytest-asyncio,
  pytest-bdd,
  pytest-localserver,
  pytest-mock,
  pytest-random-order,
  pytestCheckHook,
  pythonOlder,
  sanic,
  sanic-testing,
  setuptools,
  starlette,
  structlog,
  tornado,
  urllib3,
  webob,
  wrapt,
}:

buildPythonPackage rec {
  pname = "elastic-apm";
  version = "6.23.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "elastic";
    repo = "apm-agent-python";
    tag = "v${version}";
    hash = "sha256-S1Ebo9AWN+Mf3OFwxNTiR/AZtje3gNiYkZnVqGb7D4c=";
  };

  pythonRelaxDeps = [ "wrapt" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    blinker
    certifi
    sanic
    starlette
    tornado
    urllib3
    wrapt
  ];

  nativeCheckInputs = [
    ecs-logging
    httpx
    jinja2
    jsonschema
    logbook
    mock
    pytest-asyncio
    pytest-bdd
    pytest-localserver
    pytest-mock
    pytest-random-order
    pytestCheckHook
    sanic-testing
    structlog
    webob
  ];

  disabledTests = [ "elasticapm_client" ];

  disabledTestPaths =
    [
      # Exclude tornado tests
      "tests/contrib/asyncio/tornado/tornado_tests.py"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Flaky tests on Darwin
      "tests/utils/threading_tests.py"
    ];

  pythonImportsCheck = [ "elasticapm" ];

  meta = with lib; {
    description = "Python agent for the Elastic APM";
    homepage = "https://github.com/elastic/apm-agent-python";
    changelog = "https://github.com/elastic/apm-agent-python/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "elasticapm-run";
  };
}
