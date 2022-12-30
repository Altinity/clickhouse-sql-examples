# IEX real-time stock tracking application

## Introduction

Loads real-time stock quotes from the [IEX stock exchange](https://en.wikipedia.org/wiki/IEX)
which as of the end of 2020 accounted for 2.57% of market share. 

## Prerequisites

IEX account with API Key. See https://iexcloud.io/cloud-login#/register to sign up. 

Python 3.6.9 or greater. 

## Documentation

IEX quote interface is documented here: https://iexcloud.io/docs/api/#quote

See also the following helpful introduction to using Python to process IEX
data: https://algotrading101.com/learn/iex-api-guide/

## Setup

Copy env.sh.template to env.sh and set environmental variables found therein. 
Run `. env.sh` to set values. 

## Create schema

`./iex-01-create-schema.sh`

## Load from IEX to ClickHouse

`./iex-02-run.sh`
