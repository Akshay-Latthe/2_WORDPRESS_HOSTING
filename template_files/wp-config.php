GNU nano 7.2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               wp-config.php
<?php
 if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {$_SERVER['HTTPS'] = 'on';}

/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/documentation/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */

define( 'DB_NAME', 'mytestdb' );

/** Database username */
define( 'DB_USER', 'admin' );

/** Database password */
define( 'DB_PASSWORD', 'admin123' );

/** Database hostname */
define( 'DB_HOST', 'aurora-instance-0.cu7mlqnxm9in.us-east-1.rds.amazonaws.com' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
* the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */

define('AUTH_KEY',         'r)DVX-~jXyS:&NOa|-C8@JDN+et57B.2}H}G7Iu5g1,(6gm;n@7J,D7<,O`+qaaQ');
define('SECURE_AUTH_KEY',  'jn-Afqts-Lq0R==nm[TM37TKX+zTTyC P?a=f)L-9u*ngQ9aS=4?9<tTl6!L_f#H');
define('LOGGED_IN_KEY',    's+:h zs8$( e- BmiMFn4}#SLQO?:-!gAm3ex+&c624i&SgX*93X+V592^NAS*j_');
define('NONCE_KEY',        ',19r}+v1ntOb:oBa16wbY%0MsZ6.&]mgk#P{d5:ZCGAl|CC+Cxv<.C=$MD`%d&Tk');
define('AUTH_SALT',        'zW@)[sJr2qH:~AiL`l|Q/>XF((>~ET+63vn-$;6Xma?p1zlH<Wj?Q+%5_R:md<^:');
define('SECURE_AUTH_SALT', '.+6BvXq66a{^+sl),xve,yE)gO:#&~_oc?#=5PT,4/UP6*!-~v3y2UH#0wxxZ~K+');
define('LOGGED_IN_SALT',   '.i[|+W:XpA/Pr:@mchf| V:OY8,wdNZ^?KDRqq)g-t.M`x,SAR+rfhz1,lEP2Fr@');
define('NONCE_SALT',       '#pN+k<#tqDX5}mdvq{8fe7X]ZQ6%Wm.>a|oVH+|=|=,6->{(*lKRX&[ljJtW4m+c');




/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';
/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/documentation/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}
/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';





#!/bin/bash

# Set the database credentials and host
DB_NAME="your_db_name"
DB_USER="your_db_user"
DB_PASSWORD="your_db_password"
DB_HOST="your_db_host"

WP_CONFIG="/var/www/html/wp-config-sample.php"

sed -i "s/define( 'DB_NAME', 'database_name_here' );/define( 'DB_NAME', '$DB_NAME' );/" "$WP_CONFIG"
sed -i "s/define( 'DB_USER', 'username_here' );/define( 'DB_USER', '$DB_USER' );/" "$WP_CONFIG"
sed -i "s/define( 'DB_PASSWORD', 'password_here' );/define( 'DB_PASSWORD', '$DB_PASSWORD' );/" "$WP_CONFIG"
sed -i "s/define( 'DB_HOST', 'localhost' );/define( 'DB_HOST', '$DB_HOST' );/" "$WP_CONFIG"

echo "WordPress wp-config.php file has been configured successfully."
