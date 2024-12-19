<?php
unset($CFG);
global $CFG;
$CFG = new stdClass();

@error_reporting(E_ALL | E_STRICT);
@ini_set('display_errors', '1');
$CFG->debug = (E_ALL | E_STRICT);
$CFG->debugdisplay = 1;

$CFG->dbtype    = 'mariadb';    //changes with actual db type (MySql, Mariadb, PostgreSQL)
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'moodle-db.moodle.svc.cluster.local'; //This is only for internal kubernetes db service dns. Changes this with the actual db host
$CFG->dbname    = 'moodle';   //changes with actual db name
$CFG->dbuser    = 'moodleuser'; //Cghanges with actual db user
$CFG->dbpass    = '1somepass';  //changes with actual db password
$CFG->prefix    = 'mdl_';
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => '3306',   //changes with actual db port
  'dbsocket' => '',
);

$CFG->wwwroot   = 'https://moodle-test.com';   //changes with actual moodle exposed url, if suing nodePort, changes into http://{IP Addr}:{NodePort}
$CFG->dataroot  = '/var/www/html/moodledata';
$CFG->admin     = 'admin';
$CFG->session_handler_class = '\core\session\file';
$CFG->session_file_save_path = '/var/lib/php/sessions';

$CFG->directorypermissions = 02777;
$CFG->slasharguments = false;

require_once(__DIR__ . '/lib/setup.php');
