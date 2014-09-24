<?php
/**
 * Gymia Pre-Job Test
 * URL Shortner
 *
 * @author      MarQuis Knox <hire@marquisknox.com>
 * @copyright   2014 MarQuis Knox
 * @link        http://marquisknox.com
 * @license     Affero General Public License
 * @license     http://www.gnu.org/licenses/agpl-3.0.html
 *
 * @since  	    Wednesday, September 24, 2014, 05:34 AM GMT+1
 * @modified    $Date$ $Author$
 * @version     $Id$
 *
 * @category    Config
 * @package     Gymia Pre-Job Test
*/

// error reporting
error_reporting( E_ALL );
ini_set( 'display_errors', true );

// time zone
date_default_timezone_set( 'UTC' );

// error log
ini_set( 'error_log', dirname( dirname( dirname( __FILE__ ) ) ).'/data/logs/error/php/'.date('m-d-Y').'.log' );

// constants
require_once('constants.php');

// include path
set_include_path(
    BASEDIR.'/includes/'.PATH_SEPARATOR.
    BASEDIR.'/library/'.PATH_SEPARATOR.
    get_include_path()
);

// auto-loading
require_once('Zend/Loader/Autoloader.php');
$Zend_Loader_Autoloader = Zend_Loader_Autoloader::getInstance();
$Zend_Loader_Autoloader->registerNamespace( 
    array('Gymia_', 'Zend_') 
);
$Zend_Loader_Autoloader->setFallbackAutoloader( false );

// global functions
require_once('functions.php');

// DB config
require_once( BASEDIR.'/application/config/db/db.php' );